params.multiqc_config = "${moduleDir}/multiqc_config.yml"

process RNAMultiQC {
    label 'medium'
    tag "report"

    container 'docker://zinno/rnatools:latest'

    publishDir "${params.out}/multiqc", mode: 'symlink'

    input:
    path(fastp_data)
    path(star_data)


    output:
    path("${params.sample_id}_multiqc_report.html")

    script:
    """
    cat ${fastp_data} ${star_data} > all_data.txt

    multiqc \
        --config ${params.multiqc_config} \
        --file-list all_data.txt \
        --filename ${params.sample_id}_multiqc_report.html
    """
    stub:
    """
    touch ${params.sample_id}_multiqc_report.html
    """
}