#!/bin/bash -euo pipefail
curl \
    --retry 5 --continue-at - --max-time 1200 \
    -L ftp.sra.ebi.ac.uk/vol1/fastq/ERR112/096/ERR11202896/ERR11202896_1.fastq.gz \
    -o ERX10632306_ERR11202896_1.fastq.gz

echo "8cdf01d4a1a429dbd5014726e9f0d733  ERX10632306_ERR11202896_1.fastq.gz" > ERX10632306_ERR11202896_1.fastq.gz.md5
md5sum -c ERX10632306_ERR11202896_1.fastq.gz.md5

curl \
    --retry 5 --continue-at - --max-time 1200 \
    -L ftp.sra.ebi.ac.uk/vol1/fastq/ERR112/096/ERR11202896/ERR11202896_2.fastq.gz \
    -o ERX10632306_ERR11202896_2.fastq.gz

echo "e27fdd4822fc0772d828fe915e7a2c03  ERX10632306_ERR11202896_2.fastq.gz" > ERX10632306_ERR11202896_2.fastq.gz.md5
md5sum -c ERX10632306_ERR11202896_2.fastq.gz.md5

cat <<-END_VERSIONS > versions.yml
"NFCORE_FETCHNGS:SRA:SRA_FASTQ_FTP":
    curl: $(echo $(curl --version | head -n 1 | sed 's/^curl //; s/ .*$//'))
END_VERSIONS
