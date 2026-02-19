def interval_key(interval) {
    interval.toString().trim().replace(':', '_').replace('-', '_')
}

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
    cat > intervals.bed <<EOF
chr1:0-100000000
chr1:100000000-200000000
chr1:200000000-248956422
chr2:0-100000000
chr2:100000000-200000000
chr2:200000000-242193529
chr3:0-100000000
chr3:100000000-198295559
chr4:0-100000000
chr4:100000000-190214555
chr5:0-100000000
chr5:100000000-181538259
chr6:0-100000000
chr6:100000000-170805979
chr7:0-100000000
chr7:100000000-159345973
chr8:0-100000000
chr8:100000000-145138636
chr9:0-100000000
chr9:100000000-138394717
chr10:0-100000000
chr10:100000000-133797422
chr11:0-100000000
chr11:100000000-135086622
chr12:0-100000000
chr12:100000000-133275309
chr13:0-100000000
chr13:100000000-114364328
chr14:0-100000000
chr14:100000000-107043718
chr15:0-100000000
chr15:100000000-101991189
chr16:0-90338345
chr17:0-83257441
chr18:0-80373285
chr19:0-58617616
chr20:0-64444167
chr21:0-46709983
chr22:0-50818468
chrX:0-100000000
chrX:100000000-156040895
chrY:0-57227415
EOF
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
    path("${joint_vcf.simpleName}_${interval_key(interval)}.vcf.gz"), emit: split_vcf

    script:
    """
    ln -s \$(readlink -f ${joint_vcf}).tbi . 
    bcftools view -r ${interval.trim()} ${joint_vcf} -Oz > ${joint_vcf.simpleName}_${interval_key(interval)}.vcf.gz
    tabix -p vcf ${joint_vcf.simpleName}_${interval_key(interval)}.vcf.gz
    """
    stub:
    """
    touch ${joint_vcf.simpleName}_${interval_key(interval)}.vcf.gz
    touch ${joint_vcf.simpleName}_${interval_key(interval)}.vcf.gz.tbi
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
        path("${gvcf.simpleName}_${interval_key(interval)}.g.vcf.gz"),
        path("${gvcf.simpleName}_${interval_key(interval)}.g.vcf.gz.tbi"),
        emit: split_gvcf

    script:
    """
    ln -s \$(readlink -f ${gvcf}).tbi .
    bcftools view -r ${interval.trim()} ${gvcf} -Oz > ${gvcf.simpleName}_${interval_key(interval)}.g.vcf.gz
    tabix -p vcf ${gvcf.simpleName}_${interval_key(interval)}.g.vcf.gz
    """
    stub:
    """
    touch ${gvcf.simpleName}_${interval_key(interval)}.g.vcf.gz
    touch ${gvcf.simpleName}_${interval_key(interval)}.g.vcf.gz.tbi
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
