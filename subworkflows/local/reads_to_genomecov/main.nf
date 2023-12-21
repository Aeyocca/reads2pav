//
// Subworkflow for bwa_mem2, samtools sort, then bedtools genomecov
//

/*
========================================================================================
    IMPORT MODULES/SUBWORKFLOWS
========================================================================================
*/

include { BWAMEM2_INDEX } from '../../../modules/nf-core/bwamem2/index/main'
include { BWAMEM2_MEM } from '../../../modules/nf-core/bwamem2/mem/main'
include { BEDTOOLS_GENOMECOV } from '../../../modules/nf-core/bedtools/genomecov/main'

workflow BWAMEM2_ALIGNER {
    take:
    meta
    reads_ch            // channel: [ val(meta), [ reads ] ]
    genome          // channel: file(ref_genome)

    main:

    ch_versions = Channel.empty()

    //
    // index the genome with bwamem2 index
    //
    BWAMEM2_INDEX ( meta, genome )
    ch_versions = ch_versions.mix(BWAMEM2_INDEX.out.versions)

    //
    // Map reads with bwamem2 mem
    //
    sort_bam = true
    BWAMEM2_MEM ( reads_ch, BWAMEM2_INDEX.out.index, sort_bam )
    ch_versions = ch_versions.mix(BWAMEM2_MEM.out.versions)

    emit:
    bam            = BWAMEM2_MEM.out.bam  // channel: [ val(meta), [ bam ] ]
    versions       = ch_versions          // channel: [ versions.yml ]
}

workflow GENOMECOV {
    take:
    meta
    bam
    scale
    
    main:
    
    BEDTOOLS_GENOMECOV(meta.id,bam,scale)
    
    
    emit:
    bed
}

