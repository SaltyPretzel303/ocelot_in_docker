FROM hparch/gpuocelot 

RUN mkdir /src
COPY ./oc_build.sh /src/oc_build.sh

# entrypoint inherited from the base image 