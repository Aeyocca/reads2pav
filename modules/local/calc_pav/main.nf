process CALC_PAV {
    tag "$meta.id"
    label 'process_low'
    label 'error_retry'
    
    input:
    tuple val(meta), path(genomecov)
    
    output:
    tuple val(meta), path("*.pav.txt"), emit: pav_output
    path  "versions.yml"           , emit: versions
    
    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    
    calc_pav.py --input ${genomecov} --bed ${params.ref_bed} \\
    --depth_threshold ${params.depth_threshold} \\
    --cov_threshold ${params.cov_threshold} \\
    --output ${prefix}.pav.txt
    
    """
}