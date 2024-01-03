#!/usr/bin/env nextflow

process SPLIT_FASTA {
    input:
    tuple val(chr), val(genome_ch)
    
    output:
    tuple val(chr), path("split_genome/*"), emit: split_genome

    script:
    chr_string = chr.replaceAll(/\[/, "").replaceAll(/\]/, "")
    output = genome_ch.genome.baseName + "_" + chr_string
    
    """
    
    mkdir split_genome
    
    subset_fa.pl \\
    -f ${genome_ch.genome} \\
    -s ${chr_string} \\
    -o split_genome/${output}
    
    """
}

workflow MERGE_PAV {

    take:
    sample_ch

    main:
    ch_versions = Channel.empty()
    
    // combine split chromosomes into a single file
    
    sample_ch.view()

    COMB_CHR(sample_ch)
    
    emit:
    COMB_CHR.out.comb_chr = comb_chr
    versions = ch_versions
    
}