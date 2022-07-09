#include <stdio.h>

int main(void)
{

	int device;
	cudaGetDevice(&device);

	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, device);

	// just a few random properties 
	printf("Here is a few random cuda device properties ... \n");
	printf("Name: %s\n", deviceProp.name);
	printf("Regs per block: %d\n", deviceProp.regsPerBlock);
	printf("Max threads per block: %d\n", deviceProp.maxThreadsPerBlock);
	printf("Max grid size: %d\n", deviceProp.maxGridSize[0]);
	printf("Multi-proc count: %d\n", deviceProp.multiProcessorCount);
	printf("ECC enabled: %d\n", deviceProp.ECCEnabled);
	printf("Memory bus witdh: %d\n", deviceProp.memoryBusWidth);
	printf("Max threads per multi-proc: %d\n", deviceProp.maxThreadsPerMultiProcessor);
	printf("Warp size: %d \n", deviceProp.warpSize);

	cudaDeviceReset();

	return 0;
}