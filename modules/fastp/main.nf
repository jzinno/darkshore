params.adapters = "${moduleDir}/adapters.fasta"

process FastP {
    label 'trim'
    tag "trimming"

    container 'docker://zinno/rnatools:latest'

    publishDir "${params.out}/fastp", mode: 'symlink'

    input:
    path(fastqs)


    output:
    tuple path("${fastqs[0].simpleName}.fastp.fastq.gz"), path("${fastqs[1].simpleName}.fastp.fastq.gz"), emit: trimmed
    path("*.json"), emit: fastp_json
    path("*.fastp.html")
    path("*.fastp.failed.fastq.gz"), emit: failed


    script:
    """
    prefix=\$(echo "${fastqs[0].simpleName}" | rev | cut -d'_' -f2- | rev)

    fastp \
        -i ${fastqs[0]} \
        -I ${fastqs[1]} \
        -o ${fastqs[0].simpleName}.fastp.fastq.gz \
        -O ${fastqs[1].simpleName}.fastp.fastq.gz \
        --overrepresentation_analysis \
        --detect_adapter_for_pe \
        --adapter_fasta ${params.adapters} \
        --trim_poly_x \
        --average_qual 20 \
        --json \$prefix.json \
        --html \$prefix.fastp.html \
        --failed_out \$prefix.fastp.failed.fastq.gz \
        --thread ${task.cpus} \

    """
    stub:
    """
    prefix=\$(echo "${fastqs[0].simpleName}" | rev | cut -d'_' -f2- | rev)
    touch ${fastqs[0].simpleName}.fastp.fastq.gz
    touch ${fastqs[1].simpleName}.fastp.fastq.gz
    touch \${prefix}.fastp.json
    touch \${prefix}.fastp.html
    touch \${prefix}.fastp.failed.fastq.gz
    """
}