//
// Test subworkflow to wc fastq files
//


process WC_FASTQ  {

    input:
    val(meta)
    
    script:
    """
    echo ${meta} > tmp.txt
    """
}

