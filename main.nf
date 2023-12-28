#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { FETCHNGS           } from './subworkflows/nf-core/fetchngs'
include { BWA_IDX_BY_CHR     } from './subworkflows/local/bwa_idx_by_chr/main'
include { BWAMEM2_MEM        } from './modules/nf-core/bwamem2/mem/main'
include { BEDTOOLS_GENOMECOV } from './modules/nf-core/bedtools/genomecov/main'
include { SETUP_READ_CHANNEL } from './subworkflows/local/setup_read_channel'
include { CALC_PAV           } from './modules/local/calc_pav/main'

def index_input = [meta : [], ref_genome : file( params.ref_genome )]
genome_ch = Channel
    .of([meta : [], ref_genome : file(params.ref_genome)])

extension = "genomecov"
sort_bam = true

//unnecessary since feeding genomecov a bam file, but still needs positional arg
sizes = [] 

chrom_ch = Channel
    .fromPath( params.chrom_list )
    .splitCsv(header: false)

workflow {
    ch_versions = Channel.empty()
    
    FETCHNGS()
    ch_versions = ch_versions.mix(FETCHNGS.out.versions)
    
    // write your own bwa subworkflow to split by chromosome...
    BWA_IDX_BY_CHR(index_input, chrom_ch)
    
    // BWAMEM2_INDEX( index_input )
    // ch_versions = ch_versions.mix(BWAMEM2_INDEX.out.versions)
    
    // split each reads channel by chromosome
    
    BWA_IDX_BY_CHR.chr_out.view() // has all the indexed genomes.. I hope
     
    // BWAMEM2_MEM( FETCHNGS.out.reads , BWAMEM2_INDEX.out.index, sort_bam )
    // ch_versions = ch_versions.mix(BWAMEM2_MEM.out.versions)
    
    // BEDTOOLS_GENOMECOV(BWAMEM2_MEM.out.bam, sizes, extension)
    // ch_versions = ch_versions.mix(BEDTOOLS_GENOMECOV.out.versions)
    
    // CALC_PAV(BEDTOOLS_GENOMECOV.out.genomecov, file(params.ref_bed))
    // ch_versions = ch_versions.mix(CALC_PAV.out.versions)
    
}

