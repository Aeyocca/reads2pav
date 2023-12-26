#!/usr/bin/env nextflow

workflow SETUP_READ_CHANNEL {

    take:
    ch_sra_metadata

    main:
    
    ch_sra_metadata.view()
    
    // reads_ch = Channel.fromFilePairs(params.outdir + "/fastq/" + 
        ch_sra_metadata.id + "*{1,2}.fastq.gz")
        .view()
    
    // emit:
    // reads_ch = reads_ch
}
