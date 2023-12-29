#!/usr/bin/env nextflow

include { BWAMEM2_MEM      } from '../../../modules/nf-core/bwamem2/mem/main'

workflow BWAMEM2_PER_CHR {

    take:
    reads_per_chrom_ch

    main:
    ch_versions = Channel.empty()
    
    // 

    emit:
    chr_out = BWAMEM2_INDEX.out.index
    
}