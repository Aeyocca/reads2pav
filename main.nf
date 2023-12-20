#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.list = 'sra_list.txt'

if (params.input_type == 'sra')     include { SRA     } from './workflows/sra'

