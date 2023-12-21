//
// Test subworkflow to wc fastq files
//


process WC_FASTQ  {

    input:
    tuple val(meta)
    
    script:
    """
    echo ${meta}
    """
}

