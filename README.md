# ocelot_in_docker

How and why to use. 

1)  Install docker. 
2)  Clone this repository and navigate to it (git clone https://github.com/saltypretzel303/ocelot_in_docker; cd ocelot_in_docker)
3)  `$ docker build --tag oc_gpu --file oc.Dockerfile . `
4)  `$ docker run -it --rm --name oc_container oc_gpu`

This will create docker container capable of running cuda code on the CPU. 

5)  Write your own cuda code in the file with .cu extension (might be that it doesn't have to be .cu). 
    Or just use on of the provided scripts for testing if oc_container is working. 
    - get_props.cu -> will just print some of the device properties, some of them might have invalid values because after all 
        they are gonna be read from 'simulator' and not an actuall device. 
    - hello.cu -> will calculate the sum of two numbers on the gpu 
    - ocelot_test.cu -> will pass array of 1k elements to the 'gpu' and calculate another 1k elements based on the first array, 
        inludes device memory allocation, memcpy from device to host and from host to device, allocation of shared memory on device, 
        writing to the device global memory and thread synchronization. 

6)  `$ ./run_on_ocelot.sh script_name oc_container`

This will build and execute script 'script_name' inside the oc_container (contianer name can be changed in step 4.). 
(Of course replace script_name with the name/path fo your script). 

While your sripts are still in development it could be smart to test it on the simulator first beacuse in the case of some 
thread locks or infinite loops your gpu will be unusable for further testing and if that is your only gpu you will have to 
reboot the machine to use it again. Same script on simulator will either break and exit on its own or you will simply be able 
to cancel it with the `ctrl+c` which is not the case if it is run on GPU.
Or if you simply do not have nvidia gpu this can be handy for some educational purpose.
