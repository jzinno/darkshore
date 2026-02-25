process UGDeepVariantGPU {
    label 'gpu'
    tag 'ug-deepvariant'

    container 'docker://zinno/ugdvnv:revendreth'

    publishDir "${params.out}/ug-deepvariant", mode: 'symlink'

    input:
    path(bam_file)
    path(bam_index)

    output:
    path("${bam_file.baseName}.g.vcf.gz"), emit: gvcfs
    path("${bam_file.baseName}.g.vcf.gz.tbi"), emit: gvcf_indices


    script:
    """
    pbrun deepvariant \
        --ref ${params.ref} \
        --in-bam ${bam_file}  \
        --out-variants ${bam_file.baseName}.g.vcf \
        --num-gpus 1 \
        --pb-model-file /opt/deepvariant/models/ultima_v1.2_model_noTF32_2208_L40S.eng \
        --channel-hmer-deletion-quality \
        --channel-hmer-insertion-quality \
        --channel-non-hmer-insertion-quality \
        --aux-fields-to-keep tp,t0 \
        --skip-bq-channel \
        --min-base-quality 5 \
        --dbg-min-base-quality 0 \
        --vsc-min-fraction-indels 0.06 \
        --vsc-min-fraction-snps 0.12 \
        --ws-min-windows-distance 20 \
        --max-read-size-512 \
        --no-channel-insert-size \
        --disable-use-window-selector-model \
        --p-error 0.005 \
        --channel-ins-size \
        --max-ins-size 10 \
        --vsc-min-fraction-hmer-indels 0.12 \
        --consider-strand-bias \
        --vsc-turn-on-non-hmer-ins-proxy-support \
        --gpu-num-per-partition 1 \
        --run-partition \
        --num-cpu-threads-per-stream 4 \
        --num-streams-per-gpu 2 \
        --gvcf

    bgzip -f -@${task.cpus} ${bam_file.baseName}.g.vcf
    tabix -p vcf ${bam_file.baseName}.g.vcf.gz
    """
  stub:
    """
    touch ${bam_file.baseName}.g.vcf.gz
    touch ${bam_file.baseName}.g.vcf.gz.tbi
    """
}

process UGDeepVariantCPU {
    label 'large'
    tag 'ug-deepvariant'

    container 'docker://zinno/ugdv:latest'

    publishDir "${params.out}/ug-deepvariant", mode: 'symlink'

    input:
    path(bam_file)
    path(bam_index)

    output:
    path("${bam_file.baseName}.g.vcf.gz"), emit: gvcfs
    path("${bam_file.baseName}.g.vcf.gz.tbi"), emit: gvcf_indices


    script:
    """
    export TMPDIR=\$PWD/tmp

    if [ ! -d "\$TMPDIR" ]; then
        mkdir -p "\$TMPDIR"
    fi

    run_deepvariant \
        --make_examples_extra_args min_base_quality=5,dbg_min_base_quality=0,vsc_min_fraction_indels=0.06,vsc_min_fraction_hmer_indels=0.12,vsc_min_fraction_snps=0.12,vsc_min_count_snps=2,ws_min_windows_distance=20,min_mapping_quality=5,candidate_min_mapping_quality=5,max_reads_per_partition=1500,aux_fields_to_keep=tp+t0,skip_bq_channel=true,channels=hmer_deletion_quality+hmer_insertion_quality+non_hmer_insertion_quality,add_ins_size_channel=true,max_ins_size=10,p_error=0.005,optimal_coverages=50 \
        --model_type WGS \
        --customized_model /opt/deepvariant/models/v1.2_rc2/model.ckpt-710000 \
        --ref ${params.ref} \
        --reads ${bam_file} \
        --num_shards ${task.cpus} \
        --output_vcf ${bam_file.baseName}.vcf.gz \
        --output_gvcf ${bam_file.baseName}.g.vcf.gz \
        --intermediate_results_dir \$PWD/tmp \

    rm -rf \$PWD/tmp

    """
  stub:
    """
    touch ${bam_file.baseName}.g.vcf.gz
    touch ${bam_file.baseName}.g.vcf.gz.tbi
    """
}

process ILDeepVariant {
    label 'gpu'
    tag 'il-deepvariant'

    container 'docker://zinno/parabricks:4.2.1-1b'

    publishDir "${params.out}/il-deepvariant", mode: 'symlink'

    input:
    path(bam_file)
    path(bam_index)

    output:
    path("${bam_file.baseName}.g.vcf.gz"), emit: gvcfs
    path("${bam_file.baseName}.g.vcf.gz.tbi"), emit: gvcf_indices


    script:
    """
    pbrun deepvariant \
        --ref ${params.ref} \
        --in-bam ${bam_file}  \
        --out-variants ${bam_file.baseName}.g.vcf \
        --num-gpus 1 \
        --gpu-num-per-partition 1 \
        --run-partition \
        --num-cpu-threads-per-stream 4 \
        --num-streams-per-gpu 2 \
        --gvcf

    bgzip -f -@${task.cpus} ${bam_file.baseName}.g.vcf
    tabix -p vcf ${bam_file.baseName}.g.vcf.gz
    """
  stub:
    """
    touch ${bam_file.baseName}.g.vcf.gz
    touch ${bam_file.baseName}.g.vcf.gz.tbi
    """
}
