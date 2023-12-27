#!/bin/bash -euo pipefail
multiqc_mappings_config.py \
    id_mappings.csv \
    multiqc_config.yml

cat <<-END_VERSIONS > versions.yml
"FETCHNGS:NFCORE_FETCHNGS:SRA:MULTIQC_MAPPINGS_CONFIG":
    python: $(python --version | sed 's/Python //g')
END_VERSIONS
