#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.input = 'sra_list.txt'

include { SRA     } from './workflows/sra'

workflow NFCORE_FETCHNGS {

    take:
    ids // channel: database ids read in from --input

    main:

    ch_versions = Channel.empty()

    //
    // WORKFLOW: Download FastQ files for SRA / ENA / GEO / DDBJ ids
    //
    
    SRA ( ids )
    ch_versions = SRA.out.versions

    emit:
    versions = ch_versions
}

