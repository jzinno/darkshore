#!/usr/bin/env nextflow

include { Annovar } from '../../modules/annovar'
include { GenerateIntervals; SplitGVCF; MergeVCFs } from '../../modules/bedops'
include { GLNexusChunk } from '../../modules/glnexus'

workflow ChunkJointAnno {
    take:
    gvcf_list_ch

    main:
    GenerateIntervals(params.ref_idx)

    GenerateIntervals.out.intervals
        .splitText()
        .map { interval -> interval.trim() }
        .filter { interval -> interval }
        .set { intervals_chopped }

    gvcf_list_ch
        .splitText()
        .map { row -> file(row.trim()) }
        .set { gvcfs_ch }

    intervals_chopped
        .combine(gvcfs_ch)
        .set { interval_with_gvcf }

    SplitGVCF(interval_with_gvcf)

    SplitGVCF.out.split_gvcf
        .groupTuple()
        .set { chunked_gvcf_groups }

    GLNexusChunk(chunked_gvcf_groups)

    Annovar(GLNexusChunk.out.chunk_joint_vcf.map { interval, chunk_vcf -> chunk_vcf })

    Annovar.out.annovar_vcf
        .map { vcf -> vcf.toString() }
        .collectFile(name: params.sample_id, newLine: true)
        .set { annos }

    MergeVCFs(annos)

    emit:
    merged_vcf = MergeVCFs.out.merged_vcf
    merged_vcf_tbi = MergeVCFs.out.merged_vcf_tbi
}
