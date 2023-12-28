#!/usr/bin/env nextflow

include { BWAMEM2_INDEX      } from '../../../modules/nf-core/bwamem2/index/main'

process SPLIT_FASTA {
    input:
    val(chr)

    output:
    path(output)

    script:
    // output = chr[0].ref_genome.replaceFirst(/\.fasta/,"_${chr}.fasta")
    // chr_string = chr[1].replaceAll(/[/, "").replaceAll(/]/, "")
    
    output = params.ref_genome.replaceFirst(/\.fasta/,"_${chr}.fasta")
    // clean_genome = output.replaceFirst(/\.fasta/,"_${chr}.fasta")
    // chr_string = chr[0]
    """
    
    echo ${output}
    echo ${chr}
    split_fa.pl -f params.ref_genome -s ${chr} -o ${output}
    
    """
}


workflow BWA_IDX_BY_CHR {

    take:
    chrom_ch

    main:
    ch_versions = Channel.empty()
    
    SPLIT_FASTA(chrom_ch)
    
    BWAMEM2_INDEX(SPLIT_FASTA.output)
    
    // split genome by chromosome and index each

    emit:
    chr_out = BWAMEM2_INDEX.out.index
    
}