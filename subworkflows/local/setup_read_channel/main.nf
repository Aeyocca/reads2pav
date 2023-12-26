#!/usr/bin/env nextflow

workflow SETUP_READ_CHANNEL {

    take:
    val(ch_sra_metadata)

    main:
    
    reads_ch = Channel.fromFilePairs(params.outdir + "/fastq/" + 
        ch_sra_metadata.id + "*{1,2}.fastq.gz")
        .view()
    
    // reads_ch = Channel.of(["SRR",["read_one","read_two"]])
    
    emit:
    reads_ch = reads_ch
}
