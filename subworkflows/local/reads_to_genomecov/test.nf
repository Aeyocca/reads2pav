//
// Subworkflow for bwa_mem2, samtools sort, then bedtools genomecov
//

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { READS_TO_GENOMECOV                } from '../reads_to_genomecov'

workflow {
    input:
    reads = [path("test/" + params.sra + "_1.fastq.gz"),
             path("test/" + params.sra + "_2.fastq.gz")]
    genome
    genome_fai
    
    READS_TO_GENOMECOV(reads, genome, genome_fai)
}