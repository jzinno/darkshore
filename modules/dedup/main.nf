process MarkDuplicatesSpark {
    if ("${workflow.stubRun}" == "false") {
        memory '64 GB'
        cpus 8
        queue 'pe2'
    }

    tag 'dedup'

    publishDir "${params.out}/dedup", mode: 'symlink'

    input:
    path(bam_file)
    val(ref)

    output:
    path("${bam_file.baseName}.dedup.bam"), emit: dedup_bam
    path("${bam_file.baseName}.dedup.bam.bai"), emit: dedup_bam_index

    script:
    """
    module purge
    module load gatk/4.3.0.0
    module unload java
    module load java/1.8
    module load samtools/1.18
    
    if [ ! -d \$PWD/tmp ]; then
        mkdir \$PWD/tmp
    fi

    gatk MarkDuplicatesSpark \
        --flowbased \
        --reference ${ref} \
        --input ${bam_file} \
        --output ${bam_file.baseName}.dedup.bam \
        --conf 'spark.executor.cores=${task.cpus}' \
        --tmp-dir \$PWD/tmp \

    samtools index ${bam_file.baseName}.dedup.bam
    """
    stub:
    """
    touch ${bam_file.baseName}.dedup.bam
    touch ${bam_file.baseName}.dedup.bam.bai
    """
}

process FlowMarkDuplicates {
    if ("${workflow.stubRun}" == "false") {
        memory '16 GB'
        cpus 2
        queue 'pe2'
    }

    tag 'dedup'

    publishDir "${params.out}/dedup", mode: 'symlink'

    input:
    path(bam_file)

    output:
    path("${bam_file.baseName}.dedup.bam"), emit: dedup_bam
    path("${bam_file.baseName}.dedup.bam.bai"), emit: dedup_bam_index
    path("${bam_file.baseName}.dedup.metrics.txt"), emit: dedup_metrics

    script:
    """
    module purge
    module load gatk/4.3.0.0
    module unload java
    module load java/1.8
    
    if [ ! -d \$PWD/tmp ]; then
        mkdir \$PWD/tmp
    fi

    gatk --java-options "-Xmx12G" MarkDuplicates \
        --FLOW_MODE true \
        --INPUT ${bam_file} \
        --OUTPUT ${bam_file.baseName}.dedup.bam \
        --TMP_DIR  \$PWD/tmp \
        --METRICS_FILE ${bam_file.baseName}.dedup.metrics.txt \
        --CREATE_INDEX true

    mv ${bam_file.baseName}.dedup.bai ${bam_file.baseName}.dedup.bam.bai
    """
    stub:
    """
    touch ${bam_file.baseName}.dedup.bam
    touch ${bam_file.baseName}.dedup.bam.bai
    touch ${bam_file.baseName}.dedup.metrics.txt
    """
}

process FlowMarkDuplicatesOCI {
    if ("${workflow.stubRun}" == "false") {
        memory '16 GB'
        cpus 2
        queue 'pe2'
    }

    tag 'dedup'

    container 'docker://broadinstitute/gatk:4.5.0.0'

    publishDir "${params.out}/dedup", mode: 'symlink'

    input:
    path(bam_file)

    output:
    path("${bam_file.baseName}.dedup.bam"), emit: dedup_bam
    path("${bam_file.baseName}.dedup.bam.bai"), emit: dedup_bam_index
    path("${bam_file.baseName}.dedup.metrics.txt"), emit: dedup_metrics

    script:
    """
    if [ ! -d \$PWD/tmp ]; then
        mkdir \$PWD/tmp
    fi

    gatk --java-options "-Xmx12G" MarkDuplicates \
        --FLOW_MODE true \
        --INPUT ${bam_file} \
        --OUTPUT ${bam_file.baseName}.dedup.bam \
        --TMP_DIR  \$PWD/tmp \
        --METRICS_FILE ${bam_file.baseName}.dedup.metrics.txt \
        --CREATE_INDEX true
    """
    stub:
    """
    touch ${bam_file.baseName}.dedup.bam
    touch ${bam_file.baseName}.dedup.bam.bai
    touch ${bam_file.baseName}.dedup.metrics.txt
    """
}