#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BLOCK_DIM 32

__global__ void kernel(int *vec_a, int *vec_b, int vec_dim)
{

	__shared__ int sh_vec_a[BLOCK_DIM + 2];

	int grid_dim = gridDim.x * blockDim.x;

	// some element calculation based on the few elements around

	int step = 0;
	int steps_cnt = (vec_dim + (2 * gridDim.x) + grid_dim) / grid_dim;
	while (step < steps_cnt)
	{
		int gl_ind = (step * grid_dim) + blockDim.x * blockIdx.x + threadIdx.x;
		int stride_ind = gl_ind - blockIdx.x * 2 - step * gridDim.x * 2;

		if (stride_ind < vec_dim)
		{
			sh_vec_a[threadIdx.x] = vec_a[stride_ind];
		}
		__syncthreads();

		if (stride_ind < vec_dim)
		{
			if (threadIdx.x < BLOCK_DIM - 2)
			{
				int value = sh_vec_a[threadIdx.x] + sh_vec_a[threadIdx.x + 1] + sh_vec_a[threadIdx.x + 2];

				vec_b[stride_ind] = value;
			}
		}

		__syncthreads();

		step++;
	}

	return;
}

void init_vec(int *vec, int len, int value)
{
	for (int i = 0; i < len; i++)
	{
		vec[i] = value;
	}
}

void print_vec(int *vec, int len)
{
	for (int i = 0; i < len; i++)
	{
		printf("%d ,", vec[i]);
	}
	printf("\n");
}

int main(void)
{

	int vec_dim = 1000;

	int *vec_a = (int *)malloc(vec_dim * sizeof(int));
	int *vec_b = (int *)malloc(vec_dim * sizeof(int));

	init_vec(vec_a, vec_dim, 1);
	init_vec(vec_b, vec_dim, 0);

	int *dev_vec_a;
	int *dev_vec_b;
	cudaMalloc((void **)&dev_vec_a, vec_dim * sizeof(vec_dim));
	cudaMalloc((void **)&dev_vec_b, vec_dim * sizeof(vec_dim));

	cudaMemcpy(dev_vec_a, vec_a, vec_dim * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_vec_b, vec_b, vec_dim * sizeof(int), cudaMemcpyHostToDevice);

	// this will ensure that at least one block is spawned if vec_dim < BLOCK_DIM
	int grid_dim = (vec_dim + BLOCK_DIM) / BLOCK_DIM;

	kernel<<<1, BLOCK_DIM>>>(dev_vec_a, dev_vec_b, vec_dim);

	cudaMemcpy(vec_a, dev_vec_a, vec_dim * sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(vec_b, dev_vec_b, vec_dim * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(dev_vec_a);
	cudaFree(dev_vec_b);

	printf("Just the samples (10) ... \n");
	print_vec(vec_a, 10);
	print_vec(vec_b, 10);

	free(vec_a);
	free(vec_b);

	return 0;
}
