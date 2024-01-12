# reads2pav

This is a nextflow workflow to generate a presence-absence variation (PAV) binary matrix given a list of NCBI SRA run ids, a reference genome, and a bed file of features of interest.

This is my first attempt at writing a nextflow workflow so be kind please, but feedback is encouraged.

I combined several nf-core modules/workflows as well as written a few of my own. I also edited a few of the nf-core worflows in this repository for channel processing in a manner I could understand. I've attempted to document all changes below

Reads are downloaded with sratools, mapped to a reference with bwame2, and sequencing depth is calculated with bedtools. I wrote a python script to convert sequencing depth to a presence/absscence call based on the logic from mosdepth/sgsgeneloss though users are free to adjust horizontal and vertical coverage parameters

## quick start

"Quick" should be in quotations because you need nextflow installed. This pipeline has been exclusively tested with singularity and python3. To run on test data, Arabidopsis chloroplast.

### clone repoitory

`git clone github.com/aeyocca/readstopav`

### Launch pipeline

`
nextflow run main.nf --input sra_list.csv --outdir tmp_out/ -profile singularity --max_cpus 1
`

## Random thoughts
I have the pipeline map across each chromosome separately. In hindsight, I think this actually increases overall CPU hours? It depends on your scale I guess. There was no way I had enough CPUs to map >100 libraries across each of 17 apple chromosomes with 10 threads per process (>17k threads). An option to split chromosomes would be nice but I will probably not attempt this soon

It would be nice to have a GFF parser but GFF is a notoriously inconsistent format. Right now I'm pretty sure for genes a bed file of exons will work as my `bin/calc_pav.py` script should treat lines with identical 4th columns (1-indexed) as the same gene


## List of changes to nf-core modules/workflows:
### prefetch
- add '--max-size 1000GB' parameter

### genomecov
- removing size specification

### bwa_index
- had to create a sub directory for indexing different chromosomes
- it was overwriting other indicies,
- shouldn't each channel be executed in a separate directory??

### bwamem2_mem
- read from id\_chr value we create to map to chromosomes separately
- handle the way we feed channels in for chromosome splitting
- sort_bam always true
