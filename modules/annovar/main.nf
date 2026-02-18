process Annovar {
    if ("${workflow.stubRun}" == "false") {
        memory  { 16.GB * task.attempt }
        cpus 4
    }
    tag "annotation"

    container 'docker://zinno/annovar:latest'

    publishDir "${params.out}/annovar", mode: 'symlink'

    input:
    path(variant_file)

    output:
    path("*.hg38_multianno.vcf.gz"), emit: annovar_vcf
    path("*.hg38_multianno.vcf.gz.tbi")

    script:
    """
    prefix=\$(basename ${variant_file})
    prefix=\${prefix%.vcf.gz}
    prefix=\${prefix%.vcf}

    table_annovar.pl \
        ${variant_file} \
        ${params.resource_dir}/humandb/ \
        -buildver hg38 \
        -out \${prefix} \
        -protocol refGene,dbnsfp42c,cosmic70,avsnp150,exac03,clinvar_20220320,gnomad40_genome \
        -remove \
        -operation g,f,f,f,f,f,f \
        -nastring . \
        -vcfinput \
        -thread ${task.cpus}

    bgzip -@${task.cpus} \${prefix}.hg38_multianno.vcf
    tabix -p vcf \${prefix}.hg38_multianno.vcf.gz
    rm \${prefix}.avinput
    rm \${prefix}.hg38_multianno.txt
    """
    stub:
    """
    prefix=\$(basename ${variant_file})
    prefix=\${prefix%.vcf.gz}
    prefix=\${prefix%.vcf}
    touch \${prefix}.hg38_multianno.vcf.gz
    touch \${prefix}.hg38_multianno.vcf.gz.tbi
    """

}
