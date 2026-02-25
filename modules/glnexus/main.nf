params.glnexus_config = "${moduleDir}/darkshore.glnexus.yml"

def interval_key(interval) {
    interval.toString().trim().replace(':', '_').replace('-', '_')
}

process GLNexus {
    label 'jumbo'
    tag "glnexus"

    container 'docker://zinno/glnexus:latest'

    publishDir "${params.out}/glnexus", mode: 'symlink'

    input:
    path(gvcf_list)


    output:
    path("${params.sample_id}.glnexus.vcf.gz"), emit: joint_vcf
    path("${params.sample_id}.glnexus.vcf.gz.tbi")

    script:
    """
    glnexus_cli \
        --config ${params.glnexus_config} \
        --list ${gvcf_list} \
        --threads ${task.cpus} \
        --mem-gbytes ${task.memory.toGiga()} \
        > ${params.sample_id}.glnexus.bcf


    bcftools view ${params.sample_id}.glnexus.bcf -Oz > ${params.sample_id}.glnexus.vcf.gz
    tabix -p vcf ${params.sample_id}.glnexus.vcf.gz
    rm ${params.sample_id}.glnexus.bcf
    rm -rf GLnexus.DB

    """
    stub:
    """
    touch ${params.sample_id}.glnexus.vcf.gz
    touch ${params.sample_id}.glnexus.vcf.gz.tbi
    """
}

process GLNexusChunk {
    label 'medium'
    time '7d'
    tag "glnexus_${interval_key(interval)}"

    container 'docker://zinno/glnexus:latest'

    publishDir "${params.out}/glnexus_chunks", mode: 'symlink'

    input:
    tuple val(interval), path(gvcf_chunks), path(gvcf_chunk_indices)

    output:
    tuple val(interval),
        path("${params.sample_id}_${interval_key(interval)}.vcf.gz"),
        emit: chunk_joint_vcf
    tuple val(interval),
        path("${params.sample_id}_${interval_key(interval)}.vcf.gz.tbi"),
        emit: chunk_joint_vcf_tbi

    script:
    """
    ls -1 *.g.vcf.gz > gvcfs.${interval_key(interval)}.txt

    glnexus_cli \
        --config ${params.glnexus_config} \
        --list gvcfs.${interval_key(interval)}.txt \
        --threads ${task.cpus} \
        --mem-gbytes ${task.memory.toGiga()} \
        > ${params.sample_id}_${interval_key(interval)}.bcf

    bcftools view ${params.sample_id}_${interval_key(interval)}.bcf -Oz > ${params.sample_id}_${interval_key(interval)}.vcf.gz
    tabix -p vcf ${params.sample_id}_${interval_key(interval)}.vcf.gz
    rm ${params.sample_id}_${interval_key(interval)}.bcf
    rm -rf GLnexus.DB
    """
    stub:
    """
    ls -1 *.g.vcf.gz > gvcfs.${interval_key(interval)}.txt
    touch ${params.sample_id}_${interval_key(interval)}.vcf.gz
    touch ${params.sample_id}_${interval_key(interval)}.vcf.gz.tbi
    """
}
