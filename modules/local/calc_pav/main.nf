process CALC_PAV {
    tag "$id_chr"
    label 'process_low'
    label 'error_retry'
    
    input:
    tuple val(meta), path(genomecov), val(id_chr)
    path(ref_bed)
    
    output:
    tuple val(meta), path("*.pav.txt"), val(id_chr), emit: pav_output
    // path  "versions.yml"           , emit: versions
    
    script:
    def prefix = task.ext.prefix ?: "${id_chr}"
    """
    
    calc_pav.py --input ${genomecov} --bed ${ref_bed} \\
    --depth_threshold ${params.depth_threshold} \\
    --cov_threshold ${params.cov_threshold} \\
    --output ${prefix}.pav.txt
    
    """
}