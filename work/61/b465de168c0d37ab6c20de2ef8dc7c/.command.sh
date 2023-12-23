#!/bin/bash -euo pipefail
sra_runinfo_to_ftp.py \
    ERR11202896.runinfo.tsv \
    ERR11202896.runinfo_ftp.tsv

cat <<-END_VERSIONS > versions.yml
"FETCHNGS:NFCORE_FETCHNGS:SRA:SRA_RUNINFO_TO_FTP":
    python: $(python --version | sed 's/Python //g')
END_VERSIONS
