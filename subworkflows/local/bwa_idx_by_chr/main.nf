#!/usr/bin/env nextflow

include { BWAMEM2_INDEX      } from '../../../modules/nf-core/bwamem2/index/main'

process SPLIT_FASTA {
    input:
    path(genome)
    val(chr)

    output:
    path(output)

    script:
    chr_string = chr[0].replaceAll(/\[/, "").replaceAll(/\]/, "")
    output = genome.replaceFirst(/\.fasta/,"_${chr_string}.fasta")
    
    """
    
    echo ${output}
    echo ${chr_string}
    subset_fa.pl -f ${params.ref_genome} -s ${chr_string} -o ${output}
    
    """
}


workflow BWA_IDX_BY_CHR {

    take:
    genome_ch
    chrom_ch

    main:
    ch_versions = Channel.empty()
    
    SPLIT_FASTA(genome_ch,chrom_ch)
    
    BWAMEM2_INDEX(SPLIT_FASTA.output)
    
    // split genome by chromosome and index each

    emit:
    chr_out = BWAMEM2_INDEX.out.index
    
}