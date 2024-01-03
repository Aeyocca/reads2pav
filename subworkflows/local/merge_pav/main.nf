#!/usr/bin/env nextflow
 
include { COMB_CHR } from '../../../modules/local/comb_chr'

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