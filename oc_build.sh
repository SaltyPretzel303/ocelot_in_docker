#!/bin/bash

if [ "$#" -ne 2 ]
then 
	echo "Two arguments required ... "
	echo "First arg: path to the .cu file. "
	echo "Second arg: path to the build output file. "

	echo "e.g.: ./oc_build.sh hello.cu oc_out"

	echo "Exiting ... "
	exit 1
fi 

src_path="$1"
out_path="$2" # default was /src/oc_out

echo "Gonna build: $src_path , outputing to: $out_path ... "

nvcc -c "$src_path" -o /src/nvcc_out -arch=sm_20 
g++ -o "$out_path" /src/nvcc_out -locelot
