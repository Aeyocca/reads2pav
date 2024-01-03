#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { FETCHNGS            } from './subworkflows/nf-core/fetchngs'
include { BWA_IDX_BY_CHR      } from './subworkflows/local/bwa_idx_by_chr/main'
include { BWAMEM2_MEM         } from './modules/nf-core/bwamem2/mem/main'
include { BEDTOOLS_GENOMECOV  } from './modules/nf-core/bedtools/genomecov/main'
include { SETUP_READ_CHANNEL  } from './subworkflows/local/setup_read_channel'
include { CALC_PAV            } from './modules/local/calc_pav/main'
include { BWAMEM2_PER_CHR     } from './subworkflows/local/bwamem2_per_chr/main'
include { MERGE_PAV           } from './subworkflows/local/merge_pav/main'

// index_input = Channel.of([meta : [], ref_genome : file( params.ref_genome )])
genome_ch = Channel
    .of([meta : [], genome : file (params.ref_genome)])

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
    
    BWA_IDX_BY_CHR(genome_ch, chrom_ch)
    
    // BWAMEM2_INDEX( index_input )
    // ch_versions = ch_versions.mix(BWAMEM2_INDEX.out.versions)
    
    // split each reads channel by chromosome
    
    reads_per_chrom_ch = BWA_IDX_BY_CHR.out.idx_out
        .combine(FETCHNGS.out.reads)
        .unique()
    
    // reads_per_chrom_ch.view()
    
    // need to edit the id value, but then what is our index channel?!?
    // wrapper this as well
    
    BWAMEM2_PER_CHR(reads_per_chrom_ch)
    
    // BWAMEM2_PER_CHR.out.bam.view()
    
    // BWAMEM2_MEM( FETCHNGS.out.reads , BWA_IDX_BY_CHR.out.chr_out, sort_bam )
    // ch_versions = ch_versions.mix(BWAMEM2_MEM.out.versions)
    
    // BWAMEM2_PER_CHR.out.bam.view()
    
    BEDTOOLS_GENOMECOV(BWAMEM2_PER_CHR.out.bam, sizes, extension)
    // ch_versions = ch_versions.mix(BEDTOOLS_GENOMECOV.out.versions)
    
    CALC_PAV(BEDTOOLS_GENOMECOV.out.genomecov, file(params.ref_bed))
    // ch_versions = ch_versions.mix(CALC_PAV.out.versions)
    
    // combine pav tables across chromosomes and samples?
    // lets make this two separate tasks incase we have a single failed case
    
    // need to make a channel that is a list of CALC_PAV output files by meta.id
    sample_ch = CALC_PAV.out.pav_output.map { meta ->
        sample_id = meta[0].id
        split_file = meta[1]
        [sample_id, split_file] }
    .groupTuple()
    
    //     .collect()
    //     .groupTuple(by: 0)
    //     .view()
    
    // pav_samples = CALC_PAV.out.pav_output
    //     .join()
    //     .view()
    
    MERGE_PAV(sample_ch)
    
    // MERGE_PAV.out.comb_chr.view()
    
    // I think within the above subworkflow we will merge 
    // each sample into a single output file
    
    // MERGE_SAMPLES(MERGE_CHR.out.samples)
}

