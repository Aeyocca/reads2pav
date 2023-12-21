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

def dummy_meta = [:]
// meta is a dummy tuple while testing, going to take from fetchngs setup
dummy_meta.id = "read"

params.raw = "test/*{1,2}.fastq.gz"
reads_ch = Channel.fromFilePairs(params.raw, checkIfExists: true )
read_tuple = Channel
    .fromPath( 'test/*{1,2}.fastq.gz' )
    .collect()
    .map { 
        def meta = ["id": "reads"]

        [ meta, it ]
    } 
    .view()



genome = file( "test/Athal_chr1.fasta" )
genome_fai = "test/Athal_chr1.fasta.fai"
scale = 1

workflow {
    BWAMEM2_INDEX( meta : dummy_meta, fasta : genome )
    //  BWAMEM2_ALIGNER(reads_ch, genome)
    sort_bam = true
    BWAMEM2_MEM ( read_tuple, BWAMEM2_INDEX.out.index, sort_bam )
    GENOMECOV(dummy_meta, BWAMEM2_MEM.out.bam, scale)
}

