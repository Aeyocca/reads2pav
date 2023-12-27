process CALC_PAV {
    tag "$meta.id"
    label 'process_low'
    label 'error_retry'

    conda "bioconda::sra-tools=2.11.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sra-tools:2.11.0--pl5321ha49a11a_3' :
        'biocontainers/sra-tools:2.11.0--pl5321ha49a11a_3' }"

    input:
    tuple val(meta), path(genomecov)

    output:
    tuple val(meta), path("*.pav.txt"), emit: pav_output
    // path  "versions.yml"                   , emit: versions

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    calc_pav.py --input ${genomecov} --bed ${prefix}.bed \
    --depth_threshold ${params.depth_threshold} --cov_threshold ${params.cov_threshold} \
    --output ${prefix}.pav.txt
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """