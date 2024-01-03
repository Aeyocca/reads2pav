process COMB_CHR {
    tag "$id"
    label 'process_low'
    label 'error_retry'

    input:
    tuple val(id), val(file_list)

    output:
    path("*_comb_chr_pav.txt"), emit: comb_chr

    script:
    
    """
    
    comb_chr.py --file_list ${file_list} --out ${id}_comb_chr_pav.txt
    
    """

}