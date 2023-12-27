#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { FETCHNGS           } from './subworkflows/nf-core/fetchngs'
include { BWAMEM2_INDEX      } from './modules/nf-core/bwamem2/index/main'
include { SAMTOOLS_FAIDX     } from './modules/nf-core/samtools/faidx/main'
include { BWAMEM2_MEM        } from './modules/nf-core/bwamem2/mem/main'
include { BEDTOOLS_GENOMECOV } from './modules/nf-core/bedtools/genomecov/main'
include { SETUP_READ_CHANNEL } from './subworkflows/local/setup_read_channel'
include { CALC_PAV           } from './modules/local/calc_pav/main'

// reads_ch = Channel
//    .fromFilePairs("test/*{1,2}.fastq.gz")
def index_input = [meta : [], ref_genome : file( params.ref_genome )]
def faidx_input = [meta : [], fai : file( params.ref_genome + ".fai")]

genome_ch = Channel
    .of([meta : [], ref_genome : file(params.ref_genome)])
// genome_ch = Channel.fromPath(meta : [], ref_genome : file(params.ref_genome))
// genome = file( "test/Athal_chr1.fasta" )
// sizes = Channel.fromPath("test/Athal_chr1.fasta.fai")
extension = "genomecov"
sort_bam = true
sizes = [] //unnecessary since feeding genomecov a bam file

workflow {
    ch_versions = Channel.empty()
    
    FETCHNGS()
    ch_versions = ch_versions.mix(FETCHNGS.out.versions)
    
    SAMTOOLS_FAIDX( genome_ch , faidx_input)
    ch_versions = ch_versions.mix(SAMTOOLS_FAIDX.out.versions)
    
    SAMTOOLS_FAIDX.out.fai.view()
    
    BWAMEM2_INDEX( index_input )
    ch_versions = ch_versions.mix(BWAMEM2_INDEX.out.versions)
     
    BWAMEM2_MEM( FETCHNGS.out.reads , BWAMEM2_INDEX.out.index, sort_bam )
    ch_versions = ch_versions.mix(BWAMEM2_MEM.out.versions)
    
    BEDTOOLS_GENOMECOV(BWAMEM2_MEM.out.bam, sizes, extension)
    ch_versions = ch_versions.mix(BEDTOOLS_GENOMECOV.out.versions)
    
    CALC_PAV(BEDTOOLS_GENOMECOV.out.genomecov, SAMTOOLS_FAIDX.out.fai)
    ch_versions = ch_versions.mix(CALC_PAV.out.versions)
    
}

