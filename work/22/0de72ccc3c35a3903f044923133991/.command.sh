#!/bin/bash -euo pipefail
calc_pav.py --input ERX10632306_ERR11202896.genomecov --bed ERX10632306_ERR11202896.bed \
--depth_threshold 1 \
--cov_threshold 0.8 \
--output ERX10632306_ERR11202896.pav.txt
