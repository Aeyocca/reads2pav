//
// Subworkflow for bwa_mem2, samtools sort, then bedtools genomecov
//

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

nextflow.enable.dsl = 2

include { BWAMEM2_ALIGNER                } from '../reads_to_genomecov'
include { GENOMECOV                      } from '../reads_to_genomecov'
include { BWAMEM2_INDEX } from '../../../modules/nf-core/bwamem2/index/main'
include { BWAMEM2_MEM } from '../../../modules/nf-core/bwamem2/mem/main'

params.raw = "test/*{1,2}.fastq.gz"
reads_ch = Channel.fromFilePairs(params.raw, checkIfExists: true )
genome = file("test/Athal_chr1.fasta")
genome_fai = "test/Athal_chr1.fasta.fai"
scale = 1
def meta = [:]
meta.id = "read"

workflow {
    BWAMEM2_INDEX( genome )
    //  BWAMEM2_ALIGNER(reads_ch, genome)
    sort_bam = true
    BWAMEM2_MEM ( reads_ch, BWAMEM2_INDEX.out.index, sort_bam )
    GENOMECOV(meta, BWAMEM2_MEM.out.bam, scale)
}
