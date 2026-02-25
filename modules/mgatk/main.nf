process MitoCall {
    label 'highmem'
    container 'docker://zinno/mgatk:latest'

    tag 'mgatk'

    publishDir "${params.out}/mgatk", mode: 'symlink'

    input:
    path(mgatk_bams)
    path(mgatk_bais)

    output:
    path("final/*")


    script:
    """
    mgatk call -i \$PWD \
            --mito-genome 'hg38' \
            --output \$PWD \
            --name ${params.sample_id} \
            --ncores ${task.cpus} \
            --alignment-quality 20 \
            --base-qual 20 \
            --emit-base-qualities
    """
    stub:
    """
    mkdir final
    touch final/${params.sample_id}.A.txt.gz
    touch final/${params.sample_id}.C.txt.gz
    touch final/${params.sample_id}.G.txt.gz
    touch final/${params.sample_id}.T.txt.gz
    touch final/${params.sample_id}.coverage.txt.gz
    touch final/${params.sample_id}.depthTable.txt
    touch final/chrM_refAllele.txt
    touch final/${params.sample_id}.rds
    touch final/${params.sample_id}.signac.rds
    """
}