# reads2pav
- combine as many nf-core modules as we can into a nextflow script
- process NGS reads to bam files
 - Call pav on a set of variants with a set of thresholds
as

List of changes to nf-core modules/workflows:
prefetch
- add '--max-size 1000GB' parameter

genomecov
- removing size specification

bwa_index
- had to create a sub directory for indexing different chromosomes
- it was overwriting other indicies,
- shouldn't each channel be executed in a separate directory??

bwamem2_mem
- read from id_chr value we create to map to chromosomes separately
- handle the way we feed channels in for chromosome splitting
- sort_bam always true
