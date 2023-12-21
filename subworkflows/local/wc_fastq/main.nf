//
// Test subworkflow to wc fastq files
//


workflow  {

    input:
    tuple val(meta)
    
    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    def outfile = meta.single_end ? "${prefix}.fastq" : prefix
    """
    wc -l ${prefix}.fastq
    """
}

