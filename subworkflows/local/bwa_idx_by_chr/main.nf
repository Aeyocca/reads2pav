#!/usr/bin/env nextflow

include { BWAMEM2_INDEX      } from '../../../modules/nf-core/bwamem2/index/main'

process SPLIT_FASTA {
    input:
    val(chr)

    output:
    path(output)

    script:
    output = params.ref_genome.replaceFirst(/\.fasta/,"_${chr}.fasta")
    """
    echo ${chr.ref_genome}
    echo ${chr[1]}
    split_fa.pl -f params.ref_genome -s ${chr} -o ${output}
    """
}


workflow BWA_IDX_BY_CHR {

    take:
    index_input
    chrom_ch

    main:
    ch_versions = Channel.empty()
    
    chr_idx = index_input.combine(chrom_ch)
    
    SPLIT_FASTA(chr_idx)
    
    BWAMEM2_INDEX(SPLIT_FASTA.output)
    
    // split genome by chromosome and index each

    emit:
    chr_out = BWAMEM2_INDEX.out.index
    
}