#!/usr/bin/env nextflow

include { FlowMarkDuplicates } from '../modules/dedup'
include { UGDeepVariantGPU; UGDeepVariantCPU } from '../modules/deepvariant'
include { CalcCont } from '../modules/calcont'
include { ChunkJointAnno } from './subworkflows/chunkJointAnno.nf'


workflow {
    Channel
        .fromPath(params.bam_list)
        .splitText()
        .map { row -> file(row.trim()) }
        .set { bams_ch }
    FlowMarkDuplicates(bams_ch.map { it })
    CalcCont(FlowMarkDuplicates.out.dedup_bam, FlowMarkDuplicates.out.dedup_bam_index)
    if (params.use_gpu){
        UGDeepVariantGPU(FlowMarkDuplicates.out.dedup_bam, FlowMarkDuplicates.out.dedup_bam_index)
        UGDeepVariantGPU.out.gvcfs
            .map { gvcf -> gvcf.toString() }
            .collectFile(name: 'gvcfs.txt', newLine: true)
            .set { gvcf_list_ch }

    }else{
        UGDeepVariantCPU(FlowMarkDuplicates.out.dedup_bam, FlowMarkDuplicates.out.dedup_bam_index)
        UGDeepVariantCPU.out.gvcfs
            .map { gvcf -> gvcf.toString() }
            .collectFile(name: 'gvcfs.txt', newLine: true)
            .set { gvcf_list_ch }
    }
    ChunkJointAnno(gvcf_list_ch)
}
