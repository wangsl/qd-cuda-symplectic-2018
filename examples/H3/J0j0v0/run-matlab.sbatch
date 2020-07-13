#!/bin/bash

#SBATCH --job-name=H3v0
#SBATCH --nodes=1
#SBATCH --cpus-per-task=7
#SBATCH --time=12:00:00
#SBATCH --mem=40GB
#SBATCH --gres=gpu:p100:1

function cleanup_tmp()
{
    if [[ $base_dir =~ ^/state/partition1/$USER ]]; then
        rm -rf $base_dir
    fi
}

#trap cleanup_tmp SIGKILL EXIT

module purge

if [ "$SLURM_JOB_TMPDIR" != "" ]; then
    base_dir=$SLURM_JOB_TMPDIR
else
    base_dir=/state/partition1/$USER/matlab-$$
fi
mkdir -p $base_dir

export MATLAB_PREFDIR=$(mktemp -d $base_dir/matlab-XXXX)

rm -rf potwave crp
mkdir -p potwave crp

export CUDA_VISIBLE_DEVICES=0

singularity exec --nv --bind $base_dir:$HOME/.matlab \
	    /home/wang/singularity-images/centos-7.6.1810.sif \
	    /share/apps/matlab/2019a/bin/matlab  -nodisplay -r \
	    "main(0,0); exit"



