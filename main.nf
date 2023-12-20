#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.list = 'sra_list.txt'


include { SRATOOLS_PREFETCH } from './modules/nf-core/sratools/prefetch/main'
include { SRATOOLS_FASTERQDUMP } from './modules/nf-core/sratools/fasterqdump/main'

Channel.fromPath(params.list)
        .splitText()
        .map { file(it) }
        .set { file_list }

workflow {
  SRATOOLS_PREFETCH(file_list)
}
