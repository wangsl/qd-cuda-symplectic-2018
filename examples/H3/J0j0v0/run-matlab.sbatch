#!/bin/bash

#SBATCH --job-name=H3
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=5:00:00
#SBATCH --mem=5GB
#SBATCH --gres=gpu:v100:1

intel=/scratch/work/wang/centos-8/intel-19.1.1.sqf:ro
cuda_1102=/scratch/work/wang/centos-8/cuda-11.0.2.sqf:ro
matlab_2020a=/scratch/work/wang/centos-8/matlab-2020a.sqf:ro

all=$intel,$cuda_1102,$matlab_2020a

if [ "$SLURM_JOB_TMPDIR" != "" ]; then
    base_dir=$SLURM_JOB_TMPDIR
else
    base_dir=/state/partition1/$USER
fi

mkdir -p $base_dir

export MATLAB_PREFDIR=$(mktemp -d $base_dir/matlab-XXXX)

rm -rf crp/* potwave/*

singularity exec --nv \
	    --bind $MATLAB_PREFDIR:$HOME/.matlab \
            --overlay $all \
            /scratch/work/wang/centos-8/centos-8.2.2004.sif \
            /bin/bash -c "
source /opt/apps/lmod/lmod/init/bash
export LMOD_DISABLE_SAME_NAME_AUTOSWAP=yes
module unuse /share/apps/modulefiles
module use /ext3/apps/modulefiles   

module purge
module load matlab/2020a
module load cuda/11.0.2
module load intel/19.1.1
matlab -nodisplay -r 'main(0,0); exit'
exit
"


