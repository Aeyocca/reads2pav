#!/usr/bin/env nextflow

process COMB_CHR {
 input:
    // tuple val(meta), path(intervals), val(scale)
    tuple val(id), val(file_list)

    output:
    path  "versions.yml"                   , emit: versions

    script:
    // split spaces from the file_list tuple
    def file_list_string = file_list.join(',')
    
    """
    echo $file_list
    echo $file_list_string
    
    #comb_chr.py --file_list ${file_list} --out ${id}_comb_chr_pav.txt
    """

}


workflow MERGE_PAV {

    take:
    sample_ch

    main:
    ch_versions = Channel.empty()
    
    // combine split chromosomes into a single file
    COMB_CHR(sample_ch)
    
    emit:
    versions = ch_versions
    
}