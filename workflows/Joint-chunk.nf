#!/usr/bin/env nextflow

include { ChunkJointAnno } from './subworkflows/chunkJointAnno.nf'

workflow {
    Channel
        .fromPath(params.gvcf_list)
        .set { gvcf_list_ch }

    ChunkJointAnno(gvcf_list_ch)
}
