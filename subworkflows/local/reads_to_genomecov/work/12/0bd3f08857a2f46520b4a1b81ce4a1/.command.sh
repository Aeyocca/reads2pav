#!/bin/bash -ue
mkdir bwamem2
bwa-mem2 \
    index \
     \
    Athal_chr1.fasta -p bwamem2/Athal_chr1.fasta

cat <<-END_VERSIONS > versions.yml
"BWAMEM2_INDEX":
    bwamem2: $(echo $(bwa-mem2 version 2>&1) | sed 's/.* //')
END_VERSIONS
