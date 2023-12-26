#!/usr/bin/env nextflow

workflow SETUP_READ_CHANNEL {

    take:
    ids

    main:

    reads_ch = Channel.fromFilePairs(params.outdir + "/fastq/" + 
        ids + "*{1,2}.fastq.gz")
        .view()
    
    emit:
    reads_ch = reads_ch
}
