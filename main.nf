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

include { PIPELINE_INITIALISATION } from './subworkflows/local/nf_core_fetchngs_utils'
include { PIPELINE_COMPLETION     } from './subworkflows/local/nf_core_fetchngs_utils'

workflow {

    //
    // SUBWORKFLOW: Run initialisation tasks
    //
    PIPELINE_INITIALISATION ()

    //
    // WORKFLOW: Run primary workflows for the pipeline
    //
    NFCORE_FETCHNGS (
        PIPELINE_INITIALISATION.out.ids
    )

    //
    // SUBWORKFLOW: Run completion tasks
    //
    PIPELINE_COMPLETION (
        NFCORE_FETCHNGS.out.versions,
        params.input_type,
        params.email,
        params.email_on_fail,
        params.hook_url,
        PIPELINE_INITIALISATION.out.summary_params
    )
}