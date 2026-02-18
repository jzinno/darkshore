params.glnexus_config = "${moduleDir}/darkshore.glnexus.yml"

process GLNexus {
    if ("${workflow.stubRun}" == "false") {
        memory "512 GB"
        cpus 32
        time "7d"
    }
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
    if ("${workflow.stubRun}" == "false") {
        memory "16 GB"
        cpus 4
        time "7d"
    }
    tag "glnexus_${interval.replaceAll("[:-]", "_").trim()}"

    container 'docker://zinno/glnexus:latest'

    publishDir "${params.out}/glnexus_chunks", mode: 'symlink'

    input:
    tuple val(interval), path(gvcf_chunks), path(gvcf_chunk_indices)

    output:
    tuple val(interval),
        path("${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.vcf.gz"),
        emit: chunk_joint_vcf
    tuple val(interval),
        path("${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.vcf.gz.tbi"),
        emit: chunk_joint_vcf_tbi

    script:
    """
    ls -1 *.g.vcf.gz > gvcfs.${interval.replaceAll("[:-]", "_").trim()}.txt

    glnexus_cli \\
        --config ${params.glnexus_config} \\
        --list gvcfs.${interval.replaceAll("[:-]", "_").trim()}.txt \\
        --threads ${task.cpus} \\
        --mem-gbytes ${task.memory.toGiga()} \\
        > ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.bcf

    bcftools view ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.bcf -Oz > ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.vcf.gz
    tabix -p vcf ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.vcf.gz
    rm ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.bcf
    rm -rf GLnexus.DB
    """
    stub:
    """
    touch ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.vcf.gz
    touch ${params.sample_id}.glnexus.${interval.replaceAll("[:-]", "_").trim()}.vcf.gz.tbi
    """
}
