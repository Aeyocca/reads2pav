#!/usr/bin/env nextflow

process COMB_CHR {

    input:
    tuple val(id), val(file_list)

    output:
    path("*_comb_chr_pav.txt"), emit: comb_chr

    script:
    
    // def file_list_string = ${file_list}.join(",")
    """
    
    echo $file_list
    
    #comb_chr.py --file_list ${file_list} --out ${id}_comb_chr_pav.txt
    
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
    
    emit:
    // COMB_CHR.out.comb_chr = comb_chr
    versions = ch_versions
    
}