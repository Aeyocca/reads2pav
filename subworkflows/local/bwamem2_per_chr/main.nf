#!/usr/bin/env nextflow

include { BWAMEM2_MEM      } from '../../../modules/nf-core/bwamem2/mem/main'

workflow BWAMEM2_PER_CHR {

    take:
    reads_per_chrom_ch

    main:
    ch_versions = Channel.empty()
    
    // reads_per_chrom_ch is
    // [chr, index_dir, meta, reads]
    
    // we want to feed bwamem2_mem reads with meta.id which == meta.id + chr
    
    // can we just string concatenate?
    
    //adjusted_ch = reads_per_chrom_ch.map { meta ->
    //        def dup = meta.clone()
    //        dup[2].id_chr = dup[2].id + "_" + dup[0]
    //        dup
    //    }
    
     adjusted_ch = reads_per_chrom_ch.map { meta ->
            meta[4] = meta[2].id + "_" + meta[0]
            meta[2].id_chr = meta[4]
            meta
        }
    adjusted_ch.view()
    
    BWAMEM2_MEM(adjusted_ch)

    emit:
    bam = BWAMEM2_MEM.out.bam
    adjusted_ch = adjusted_ch
    
}