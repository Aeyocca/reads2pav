#!/bin/bash -ue
INDEX=`find -L ./ -name "*.amb" | sed 's/\.amb$//'`

bwa-mem2 \
    mem \
     \
    -t 1 \
    $INDEX \
    read_1.fastq.gz read_2.fastq.gz \
    | samtools sort  -@ 1 -o reads.bam -

cat <<-END_VERSIONS > versions.yml
"BWAMEM2_MEM":
    bwamem2: $(echo $(bwa-mem2 version 2>&1) | sed 's/.* //')
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
