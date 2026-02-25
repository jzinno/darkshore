process TEcount {
    label 'small'
    tag "align"

    container 'docker://zinno/tetranscripts:latest'

    publishDir "${params.out}/TEcount", mode: 'symlink'

    input:
    path(bam)


    output:
    path("${bam.simpleName}.cntTable"), emit: tecount

    script:
    """
    TEcount \
        -b ${bam} \
        --GTF ${params.gtf} \
        --TE ${params.te_gtf} \
        --sortByPos \
        --project ${bam.simpleName}


    """
    stub:
    """
    touch ${bam.simpleName}.cntTable
    """
}