#!/usr/bin/env nextflow

params.list = 'sra_list.txt'


include { SRATOOLS_PREFETCH } from '../modules/nf-core/sratools/prefetch/main'
include { SRATOOLS_FASTERQDUMP } from '../modules/nf-core/sratools/fasterqdump/main'

Channel.fromPath(params.list)
        .splitText()
        .map { file(it) }
        .set { file_list }

SRATOOLS_PREFETCH(file_list)

process prefetch_batch {
  input:
  file data_file from file_list
  
  output:
  file('data_file.md5sum') into md5sum_files
  
  """
  md5 $data_file > data_file.md5sum
  """
}

process collect_md5sum {
  input:
  file('data_file??.md5sum') from md5sum_files.toList()
  
  output:
  file('primary_data.md5sum')
  
  """
  cat data_file??.md5sum > primary_data.md5sum
  """
}