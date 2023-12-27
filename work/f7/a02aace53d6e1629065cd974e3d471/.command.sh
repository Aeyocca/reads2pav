#!/bin/bash -euo pipefail
head -n 1 `ls ./samplesheets/* | head -n 1` > samplesheet.csv
for fileid in `ls ./samplesheets/*`; do
    awk 'NR>1' $fileid >> samplesheet.csv
done

head -n 1 `ls ./mappings/* | head -n 1` > id_mappings.csv
for fileid in `ls ./mappings/*`; do
    awk 'NR>1' $fileid >> id_mappings.csv
done

cat <<-END_VERSIONS > versions.yml
"FETCHNGS:NFCORE_FETCHNGS:SRA:SRA_MERGE_SAMPLESHEET":
    sed: $(echo $(sed --version 2>&1) | sed 's/^.*GNU sed) //; s/ .*$//')
END_VERSIONS
