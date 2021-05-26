#!/bin/bash

# https://stackoverflow.com/questions/1668649/how-to-keep-quotes-in-bash-arguments

args=''
for i in "$@"; do 
    i="${i//\\/\\\\}"
    args="$args \"${i//\"/\\\"}\""
done

if [ "$args" == "" ]; then args="/bin/bash"; fi

matlab="/scratch/work/public/singularity/matlab-2021a.sqf"

host=$(/bin/hostname -s)

if [[ $host =~ ^g[rv][0-9] ]]; then
    nv="--nv"
    os_image="/scratch/work/public/singularity/cuda11.1.1-cudnn8-devel-ubuntu20.04.sif"
elif [[ $host =~ ^ga-[0-9] ]]; then
    os_image="/scratch/work/public/hudson/images/rocm4.2-ubuntu20.04.sif"
fi
    
/share/apps/singularity/3.7.3/bin/singularity \
    exec $nv \
    --bind /usr/bin/numactl \
    --overlay ${matlab}:ro \
    ${os_image} \
    /bin/bash -c "
export MATLAB_ROOT=/ext3/apps/matlab/2021a
export PATH=\${MATLAB_ROOT}/bin:\$PATH
eval $args
exit
"

exit

export MATLAB_ROOT="/ext3/apps/matlab/2021a"
export PATH=${MATLAB_ROOT}/bin:$PATH

source /home/wang/hudson/env.sh

##
# source code: /home/wang/hudson/src
# test folder:
# /scratch/wang/hudson/qd-cuda-test/H3/J0j0v0-cuda
# /scratch/wang/hudson/qd-cuda-test/H3/J0j0v0-hip
