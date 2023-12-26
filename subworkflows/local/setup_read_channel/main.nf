#!/usr/bin/env nextflow


process ECHO_CHANNEL {
    input:
    ch_sra_metadata
    
    script:
    """
    echo $ch_sra_metadata
    """

}

workflow SETUP_READ_CHANNEL {

    take:
    ch_sra_metadata

    main:
    
    ECHO_CHANNEL(ch_sra_metadata)
    
    //reads_ch = Channel.fromFilePairs(params.outdir + "/fastq/" + 
    //    ch_sra_metadata.id + "*{1,2}.fastq.gz")
    //    .view()
    
    reads_ch = Channel.of(["SRR",["read_one","read_two"]])
    
    emit:
    reads_ch = reads_ch
}
