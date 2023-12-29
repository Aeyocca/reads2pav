# reads2pav
- combine as many nf-core modules as we can into a nextflow script
- process NGS reads to bam files
 - Call pav on a set of variants with a set of thresholds


List of changes to nf-core modules/workflows:
genomecov
- don't remember atm, but I definitely changed something

bwa_index
- had to create a sub directory for indexing different chromosomes
- it was overwriting other indicies,
- shouldn't each channel be executed in a separate directory??

bwamem2_mem
- read from id_chr value we create to map to chromosomes separately
