process MergeCounts {
    label 'small'
    tag "collate"

    publishDir "${params.out}/matrix", mode: 'symlink'

    input:
    path(count_list)

    output:
    path("${params.sample_id}.counts.tab")

    script:
    """
    ${moduleDir}/merge_htseq.sh ${count_list} ${params.sample_id}.counts.tab
    """
    stub:
    """
    touch ${params.sample_id}.counts.tab
    """
}

process MergeCountsTE {
    label 'small'
    tag "collate"

    publishDir "${params.out}/matrix", mode: 'symlink'

    input:
    path(count_list)

    output:
    path("${params.sample_id}.counts.tab")

    script:
    """
    ${moduleDir}/merge_tecount.sh ${count_list} ${params.sample_id}.counts.tab
    """
    stub:
    """
    touch ${params.sample_id}.counts.tab
    """
}

process VarCount {
    label 'small'
    tag "nrnv"

    publishDir "${params.out}/varcount", mode: 'symlink'

    input:
    path(vcf)

    output:
    path("${vcf.simpleName}_NR.tsv")
    path("${vcf.simpleName}_NV.tsv")

    script:
    """
    ${moduleDir}/varcount.sh ${vcf}
    """
    stub:
    """
    touch ${vcf.simpleName}_NR.tsv
    touch ${vcf.simpleName}_NV.tsv
    """
}

