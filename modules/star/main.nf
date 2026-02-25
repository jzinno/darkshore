process Star {
    label 'large'
    tag "align"

    container 'docker://zinno/rnatools:latest'

    publishDir "${params.out}/star", mode: 'symlink'

    input:
    path(trimmed)


    output:
    path("*.Aligned.sortedByCoord.out.bam"), emit: star_bam
    path("*.Aligned.sortedByCoord.out.bam.bai"), emit: star_bai
    path("*.Log.final.out"), emit: star_log
    path("*.SJ.out.tab"), emit: star_sj


    script:
    """
    prefix=\$(echo "${trimmed[0].simpleName}" | rev | cut -d'_' -f2- | rev)

    STAR \
    --runThreadN ${task.cpus} \
    --genomeDir ${params.star_ref} \
    --sjdbGTFfile ${params.gtf} \
    --twopassMode Basic \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix \${prefix}. \
    --readFilesCommand zcat \
    --readFilesIn ${trimmed[0]} ${trimmed[1]} \

    samtools index -@ ${task.cpus} \${prefix}.Aligned.sortedByCoord.out.bam

    """
    stub:
    """
    prefix=\$(echo "${trimmed[0].simpleName}" | rev | cut -d'_' -f2- | rev)
    touch \${prefix}.Aligned.sortedByCoord.out.bam
    touch \${prefix}.Aligned.sortedByCoord.out.bam.bai
    touch \${prefix}.Log.final.out
    touch \${prefix}.SJ.out.tab
    """
}

process StarTE {
    label 'large'
    tag "align"

    container 'docker://zinno/rnatools:latest'

    publishDir "${params.out}/starTE", mode: 'symlink'

    input:
    path(trimmed)


    output:
    path("*.Aligned.sortedByCoord.out.bam"), emit: star_bam
    path("*.Aligned.sortedByCoord.out.bam.bai"), emit: star_bai
    path("*.Log.final.out"), emit: star_log
    path("*.SJ.out.tab"), emit: star_sj


    script:
    """
    prefix=\$(echo "${trimmed[0].simpleName}" | rev | cut -d'_' -f2- | rev)

    STAR \
    --runThreadN ${task.cpus} \
    --genomeDir ${params.star_ref} \
    --sjdbGTFfile ${params.gtf} \
    --twopassMode Basic \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix \${prefix}. \
    --winAnchorMultimapNmax 200 \
    --outFilterMultimapNmax 100 \
    --readFilesCommand zcat \
    --readFilesIn ${trimmed[0]} ${trimmed[1]} \

    samtools index -@ ${task.cpus} \${prefix}.Aligned.sortedByCoord.out.bam

    """
    stub:
    """
    prefix=\$(echo "${trimmed[0].simpleName}" | rev | cut -d'_' -f2- | rev)
    touch \${prefix}.Aligned.sortedByCoord.out.bam
    touch \${prefix}.Aligned.sortedByCoord.out.bam.bai
    touch \${prefix}.Log.final.out
    touch \${prefix}.SJ.out.tab
    """
}