#!/bin/bash -euo pipefail
bedtools \
    genomecov \
    -ibam ERX10632306_ERR11202896.bam \
     \
    > ERX10632306_ERR11202896.genomecov

cat <<-END_VERSIONS > versions.yml
"BEDTOOLS_GENOMECOV":
    bedtools: $(bedtools --version | sed -e "s/bedtools v//g")
END_VERSIONS
