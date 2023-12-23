#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { FETCHNGS     } from './subworkflows/nf-core/fetchngs'
include { BWAMEM2_INDEX } from './modules/nf-core/bwamem2/index/main'
include { BWAMEM2_MEM } from './modules/nf-core/bwamem2/mem/main'
include { BEDTOOLS_GENOMECOV } from './modules/nf-core/bedtools/genomecov/main'

// reads_ch = Channel
//    .fromFilePairs("test/*{1,2}.fastq.gz")
def dummy_meta = []
genome = file( "test/Athal_chr1.fasta" )
// sizes = Channel.fromPath("test/Athal_chr1.fasta.fai")
// extension = "genomecov"


workflow {
    FETCHNGS()
    
    reads_ch = Channel.fromPath(params.outdir + "/samplesheet/samplesheet.csv")
        .splitCsv(header: ["id", "reads", "reads"], skip : 1)
        .groupTuple()
        .view()
    
    BWAMEM2_INDEX( meta : dummy_meta, fasta : genome )
    // //  BWAMEM2_ALIGNER(reads_ch, genome)
    sort_bam = true
    
    
    BWAMEM2_MEM ( reads_ch , BWAMEM2_INDEX.out.index, sort_bam )
    
    // BEDTOOLS_GENOMECOV(BWAMEM2_MEM.out.bam, sizes, extension)
}

