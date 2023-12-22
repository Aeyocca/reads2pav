#!/bin/bash -euo pipefail
echo ERR11202896 > id.txt
sra_ids_to_runinfo.py \
    id.txt \
    ERR11202896.runinfo.tsv \


cat <<-END_VERSIONS > versions.yml
"FETCHNGS:NFCORE_FETCHNGS:SRA:SRA_IDS_TO_RUNINFO":
    python: $(python --version | sed 's/Python //g')
END_VERSIONS
