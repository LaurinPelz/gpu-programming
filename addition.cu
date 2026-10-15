#include <stdio.h>
#include <stdlib.h>

// CUDA kernel function to add two vectors
__global__ void vectorAdd(const float *A, const float *B, float *C, long numElements) {
    // Get the unique thread ID, which is the index in the vector
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    
    // Make sure we don't go out of bounds
    if (i < numElements) {
        C[i] = A[i] + B[i];
    }
}

int main() {
    // Vector size and memory size
    long numElements = 500000000;
    int test_threadsPerBlock = 256;
    size_t size = numElements * sizeof(float);
    
    printf("Vector addition of %ld elements\n", numElements);
    
    // Allocate host memory
    float *h_A = (float *)malloc(size);
    float *h_B = (float *)malloc(size);
    float *h_C = (float *)malloc(size);
    
    // Initialize host arrays with random data
    for (long i = 0; i < numElements; ++i) {
        h_A[i] = rand() / (float)RAND_MAX;
        h_B[i] = rand() / (float)RAND_MAX;
    }
    
    cudaEvent_t start, stop;
    float time = 0;

    // Allocate device memory
    float *d_A = NULL;
    float *d_B = NULL;
    float *d_C = NULL;
    cudaMalloc((void **)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, size);

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    // Copy data from host to device
    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    
    // Launch the CUDA kernel
    int threadsPerBlock = test_threadsPerBlock;
    int blocksPerGrid = (numElements + threadsPerBlock - 1) / threadsPerBlock;
    printf("CUDA kernel launch with %d blocks of %d threads\n", blocksPerGrid, threadsPerBlock);
    
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, numElements);
    
    // Check for errors in kernel launch
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
        fprintf(stderr, "Failed to launch kernel: %s\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    
    // Copy result back to host
    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);
    
    // Verify the result
    for (long i = 0; i < numElements; ++i) {
        if (fabs(h_A[i] + h_B[i] - h_C[i]) > 1e-5) {
            fprintf(stderr, "Result verification failed at element %ld!\n", i);
            exit(EXIT_FAILURE);
        }
    }
    printf("Test PASSED\n");

    cudaEventRecord(stop);
    cudaEventElapsedTime(&time, start, stop);
    printf("GPU Time elapsed: %f ms\n", time);

    float *CPU_A;
    float *CPU_B;
    float *CPU_C;

    CPU_A = (float*)calloc(size, sizeof(float));
    CPU_B = (float*)calloc(size, sizeof(float));
    CPU_C = (float*)calloc(size, sizeof(float));
    
    memcpy(CPU_A, h_A, size);
    memcpy(CPU_B, h_B, size);
    memcpy(CPU_C, h_C, size);

    clock_t CPU_start, CPU_stop;

    CPU_start = clock();

    for(int i = 0; i < size; i++){
        CPU_C[i] = CPU_A[i] + CPU_B[i];
    } 

    CPU_stop = clock();

    double CPU_elapsed = (double)(CPU_stop - CPU_start);

    printf("CPU Time elapsed: %f ms\n", CPU_elapsed);

    // Free device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    
    // Free host memory
    free(h_A);
    free(h_B);
    free(h_C);

    free(CPU_A);
    free(CPU_B);
    free(CPU_C);
    
    printf("Done\n");
    return 0;
} 
