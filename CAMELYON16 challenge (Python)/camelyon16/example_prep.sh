#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -o /home/bramotte/last_run_out
#SBATCH -t 10:00:00
#SBATCH -p knl_flat

module load python/2.7.12-intel-u1 && export LD_LIBRARY_PATH=~/libopenslide
python ./preprocess/extract_ROIs.py && python ./preprocess/extract_patches.py && python ./preprocess/create_tfrecords.py
