#!/usr/bin/env nextflow

process COMB_CHR {

    input:
    tuple val(id), val(file_list)

    output:
    path("*_comb_chr_pav.txt"), emit: comb_chr

    script:
    
    """
    
    comb_chr.py --file_list '${file_list}' --out ${id}_comb_chr_pav.txt
    
    """

}

process COMB_SAMPLES {
    input:
    val(file_list)

    output:
    path("readstopav.txt"), emit: final_out

    script:
    
    """
    
    #actually I can probably just do this in awk... eh python is more fun
    comb_samples.py --file_list '${file_list}' --out readstopav.txt
    
    """
}

workflow MERGE_PAV {

    take:
    sample_ch

    main:
    ch_versions = Channel.empty()
    
    // combine split chromosomes into a single file
    
    // sample_ch.view()

    COMB_CHR(sample_ch)
    
    all_ch = COMB_CHR.out.comb_chr.collect()
    
    all_ch.view()
    
    COMB_SAMPLES(all_ch)
    
    emit:
    COMB_SAMPLES.out.final_out = final_out
    versions = ch_versions
    
}