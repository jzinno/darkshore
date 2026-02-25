process FlowMarkDuplicates {
    label 'dedup'
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
        --FLOW_MODE ${params.flow_mode} \
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
