#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { FETCHNGS           } from './subworkflows/nf-core/fetchngs'
include { BWAMEM2_INDEX      } from './modules/nf-core/bwamem2/index/main'
include { BWAMEM2_MEM        } from './modules/nf-core/bwamem2/mem/main'
include { BEDTOOLS_GENOMECOV } from './modules/nf-core/bedtools/genomecov/main'
include { SETUP_READ_CHANNEL } from './subworkflows/local/setup_read_channel'

// reads_ch = Channel
//    .fromFilePairs("test/*{1,2}.fastq.gz")
def index_input = [meta : [], genome = file( "test/Athal_chr1.fasta" )]
// genome = file( "test/Athal_chr1.fasta" )
sizes = Channel.fromPath("test/Athal_chr1.fasta.fai")
extension = "genomecov"


workflow {
    FETCHNGS()
    ch_versions = Channel.empty()
    
    ch_versions = ch_versions.mix(FETCHNGS.out.versions)
    
    // FETCHNGS.out.ch_sra_metadata.view()
    
    // SETUP_READ_CHANNEL(FETCHNGS.out.ch_sra_metadata)
    
    //reads_ch = Channel.fromFilePairs("fastq/" + 
    //    FETCHNGS.out.ch_sra_metadata.id + "*{1,2}.fastq_gz")
    
    BWAMEM2_INDEX( meta : dummy_meta, fasta : genome )
    // //  BWAMEM2_ALIGNER(read_ch, genome)
    sort_bam = true
     
    BWAMEM2_MEM( FETCHNGS.out.reads , BWAMEM2_INDEX.out.index, sort_bam )
        
    // BEDTOOLS_GENOMECOV(BWAMEM2_MEM.out.bam, sizes, extension)
    BEDTOOLS_GENOMECOV([index_input, BWAMEM2_MEM.out.bam, 1], sizes, extension)
    
    // BEDTOOLS_GENOMECOV.out.genomecov.view()
    
    ch_versions = ch_versions.mix(BEDTOOLS_GENOMECOV.out.versions)
}

