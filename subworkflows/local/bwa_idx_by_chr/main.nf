#!/usr/bin/env nextflow

include { BWAMEM2_INDEX      } from '../../../modules/nf-core/bwamem2/index/main'

process SPLIT_FASTA {
    input:
    tuple val(meta), path(genome), val(chr)

    output:
    tuple val(meta), path("split_genome/*"), emit: split_genome

    script:
    chr_string = chr[0].replaceAll(/\[/, "").replaceAll(/\]/, "")
    output = genome.baseName + "_" + chr_string
    
    """
    
    echo $output
    
    mkdir split_genome
    
    subset_fa.pl \\
    -f ${genome} \\
    -s ${chr_string} \\
    -o split_genome/${genome}.baseName_${chr_string}
    
    """
}


workflow BWA_IDX_BY_CHR {

    take:
    genome_ch
    chrom_ch

    main:
    ch_versions = Channel.empty()
    
    // need to combine chrom and genome channels to properly parallelize, yes?
    // genome_ch.combine(chrom_ch)
    //     .set{split_ch}
    
    split_ch = Channel.groupTuple(genome_ch,chrom_ch).view()
    
    SPLIT_FASTA(split_ch)
    
    // tuple val(meta), path(fasta)
    
    BWAMEM2_INDEX(SPLIT_FASTA.out.split_genome)
    
    // split genome by chromosome and index each

    emit:
    chr_out = BWAMEM2_INDEX.out.index
    
}