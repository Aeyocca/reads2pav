//
// Subworkflow for bwa_mem2, samtools sort, then bedtools genomecov
//

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

nextflow.enable.dsl = 2

include { READS_TO_GENOMECOV                } from '../reads_to_genomecov'

params.raw = "test/*{1,2}.fastq.gz"
reads_ch = Channel.fromFilePairs(params.raw, checkIfExists: true )
genome = "test/Athal_chr1.fasta"
genome_fai = "test/Athal_chr1.fasta.fai"

workflow {
    READS_TO_GENOMECOV(reads_ch, genome, genome_fai)
}