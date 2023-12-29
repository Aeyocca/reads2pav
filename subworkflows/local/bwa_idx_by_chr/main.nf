#!/usr/bin/env nextflow

include { BWAMEM2_INDEX      } from '../../../modules/nf-core/bwamem2/index/main'

process SPLIT_FASTA {
    input:
    path(genome)
    val(chr)

    output:
    path("split_genome"), emit: split_genome

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
    
    SPLIT_FASTA(genome_ch,chrom_ch)
    
    BWAMEM2_INDEX(SPLIT_FASTA.out.split_genome)
    
    // split genome by chromosome and index each

    emit:
    chr_out = BWAMEM2_INDEX.out.index
    
}