#!/bin/bash

hip_dir="/home/wang/hudson/src/common-hip"

cd /home/wang/hudson/src/common-cuda

for src in *.[hC] *.cu *.F; do
    echo $src
    hip_src="${hip_dir}/$src"
    /opt/rocm/bin/hipify-perl $src > $hip_src
done


