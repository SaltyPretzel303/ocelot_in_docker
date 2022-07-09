#!/bin/bash

if [ "$#" -ne 2 ]
then 
	echo "Two arguments are required ... "
	echo "First arg: path to the .cu file"
	echo "Second arg: name of the container running ocelot "

	echo "e.g.: ./run_on_ocelot.sh hello.cu ocelot_container" 

	echo "Exiting ... "
	exit 1
fi 

src="$1"
container_name="$2"

src_file=$(basename ${src})

echo "Will build and run: $src on: $container_name ... "
echo "Press enter to continue ... "

a=2
read a

# container_name='hardcore_tesla'

docker cp "$src" "$container_name":/src/"$src_file"
docker exec "$container_name" /src/oc_build.sh /src/"$src_file" /src/oc_out

build_ret="$?"
if [ "$build_ret" -ne 0 ]
then 
	echo "Build failed ... "
	exit 1
fi 

echo "Build successfull ... " 
echo "Running ... "
echo ""

docker exec "$container_name" /src/oc_out

