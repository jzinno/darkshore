process GenerateIntervals {
    if ("${workflow.stubRun}" == "false") {
        memory '2 GB'
        cpus 1
    }

    tag 'bedops'

    container 'docker://zinno/bioutils:latest'

    publishDir "${params.out}/bedops", mode: 'symlink'

    input:
    path(params.ref_idx)

    output:
    path("intervals.bed"), emit: intervals

    script:
    """
    awk '{print \$1"\t"0"\t"\$2}' ${params.ref_idx} | head -n24 | sort-bed - | bedops --chop ${params.chop} - | sort --version-sort |  awk '{print \$1":"\$2"-"\$3}' > intervals.bed
    """
    stub:
    """
    awk '{print \$1"\t"0"\t"\$2}' ${params.ref_idx} | head -n24 | sort-bed - | bedops --chop ${params.chop} - | sort --version-sort |  awk '{print \$1":"\$2"-"\$3}' > intervals.bed
    """
}

process SplitVCF {
    if ("${workflow.stubRun}" == "false") {
        memory '2 GB'
        cpus 1
    }

    tag 'bedops'

    container 'docker://zinno/bioutils:latest'

    publishDir "${params.out}/chunks", mode: 'symlink'

    input:
    tuple val(interval), path(joint_vcf)

    output:
    path("${joint_vcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.vcf.gz"), emit: split_vcf

    script:
    """
    ln -s \$(readlink -f ${joint_vcf}).tbi . 
    bcftools view -r ${interval.trim()} ${joint_vcf} -Oz > ${joint_vcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.vcf.gz
    tabix -p vcf ${joint_vcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.vcf.gz
    """
    stub:
    """
    touch ${joint_vcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.vcf.gz
    touch ${joint_vcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.vcf.gz.tbi
    """

}

process SplitGVCF {
    if ("${workflow.stubRun}" == "false") {
        memory '2 GB'
        cpus 1
    }

    tag 'bedops'

    container 'docker://zinno/bioutils:latest'

    publishDir "${params.out}/gvcf_chunks", mode: 'symlink'

    input:
    tuple val(interval), path(gvcf)

    output:
    tuple val(interval),
        path("${gvcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.g.vcf.gz"),
        path("${gvcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.g.vcf.gz.tbi"),
        emit: split_gvcf

    script:
    """
    ln -s \$(readlink -f ${gvcf}).tbi .
    bcftools view -r ${interval.trim()} ${gvcf} -Oz > ${gvcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.g.vcf.gz
    tabix -p vcf ${gvcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.g.vcf.gz
    """
    stub:
    """
    touch ${gvcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.g.vcf.gz
    touch ${gvcf.simpleName}_${interval.replaceAll("[:-]", "_").trim()}.g.vcf.gz.tbi
    """
}

process MergeVCFs {
    if ("${workflow.stubRun}" == "false") {
        memory '64 GB'
        cpus 4
    }

    tag 'bedops'

    container 'docker://zinno/bioutils:latest'

    publishDir "${params.out}/final", mode: 'symlink'

    input:
    path(annos)


    output:
    path("${annos.simpleName}.vcf.gz"), emit: merged_vcf
    path("${annos.simpleName}.vcf.gz.tbi"), emit: merged_vcf_tbi

    script:
    """
    awk -F'/' '{print \$NF,\$0}' ${annos} | sort -V | cut -d' ' -f2- > tmp.list
    bcftools concat --threads ${task.cpus} -f tmp.list -Oz -o ${annos.simpleName}.vcf.gz
    tabix -p vcf ${annos.simpleName}.vcf.gz
    """
    stub:
    """
    touch ${annos.simpleName}.vcf.gz
    touch ${annos.simpleName}.vcf.gz.tbi
    """

}
