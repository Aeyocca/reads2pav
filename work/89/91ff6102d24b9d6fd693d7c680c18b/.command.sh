#!/bin/bash -euo pipefail
INDEX=`find -L ./ -name "*.amb" | sed 's/\.amb$//'`

bwa-mem2 \
    mem \
     \
    -t 1 \
    $INDEX \
    ERX10632306_ERR11202896_1.fastq.gz ERX10632306_ERR11202896_2.fastq.gz \
    | samtools sort  -@ 1 -o ERX10632306_ERR11202896.bam -

cat <<-END_VERSIONS > versions.yml
"BWAMEM2_MEM":
    bwamem2: $(echo $(bwa-mem2 version 2>&1) | sed 's/.* //')
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
