#!/bin/bash -euo pipefail
export NCBI_SETTINGS="$PWD/user-settings.mkfg"

fasterq-dump \
    --split-files --include-technical \
    --threads 1 \
    --outfile ERX10632306_ERR11202896 \
     \
    ERR11202896

pigz \
     \
    --no-name \
    --processes 1 \
    *.fastq

cat <<-END_VERSIONS > versions.yml
"FETCHNGS:NFCORE_FETCHNGS:SRA:FASTQ_DOWNLOAD_PREFETCH_FASTERQDUMP_SRATOOLS:SRATOOLS_FASTERQDUMP":
    sratools: $(fasterq-dump --version 2>&1 | grep -Eo '[0-9.]+')
    pigz: $( pigz --version 2>&1 | sed 's/pigz //g' )
END_VERSIONS
