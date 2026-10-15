# GPUs vs CPUs (lab 1: architecture and performance)
The goal of this lab is to develop a deeper understanding of the fundamental architectural differences between GPUs and CPUs and to observe how these differences impact performance.

## Tasks (system info)
1. GPU architecture: NVIDIA RTX PRO 4000 Blackwell (nvidia-sml)
2. No. SMs: 70 (https://www.techpowerup.com/gpu-specs/rtx-pro-4000-blackwell-workstation.c4279)
3. No. SPs: 8.960 (https://www.techpowerup.com/gpu-specs/rtx-pro-4000-blackwell-workstation.c4279)
4. CPU: Intel(R) Xeon(R) w3-2525 (lscpu)
5. No. threads CPU vs no. threads GPU: 16 vs 259072

## Tasks (performance)
1. Compile and run addition

      team2@hclab02:\~/Desktop/new/gpu-programming\$ nvcc addition.cu -o addition
      
      team2@hclab02:\~/Desktop/new/gpu-programming\$ ./addition
    
      Vector addition of 50000 elements
      
      CUDA kernel launch with 196 blocks of 256 threads
      
      Test PASSED
      
      Done

3. Measure execution time GPU (hint: `cudaEvent_t start, stop;` \n `cudaEventCreate(&start);`)
    GPU time elapsed: 0.444512 ms
4. Implement CPU version
    for(int i = 0; i < size; i++){
        CPU_C[i] = CPU_A[i] + CPU_B[i];
    } 
5. Measure execution time CPU
    CPU time elapsed: 752 ms
6. Compare CPU and GPU execution with changing block sizes (as low and as high, e.g., 512, 2048, so that you can gather performance trends) and data sizes (up to and including 50 billion)
    Block size  Elements    GPU Time    CPU Time
    256         50.000      0.616 ms    752 ms
    512         50.000      0.688 ms    859 ms
    1024        50.000      0.594 ms    723 ms
    2048        50.000      invalid     invalid
    256         500.000     3.986 ms    7851 ms
    512         500.000     3.056 ms    9411 ms
    1024        500.000     2.724 ms    6991 ms
    256         500.000.000 2450 ms     6046995 ms
    512         500.000.000 2446 ms     5962833 ms
    1024        500.000.000 2444 ms     6042586 ms
7. Plot measurements and speedups (block sizes and increasing data)
    See CPUGPUMeasurePlot.jpeg
8. Compile and run race condition exercise
        team2@hclab02:~/Desktop/LPFH/gpu-programming$ nvcc      race_condition_bug.cu -o race_condition && ./race_condition
    Counting elements > 0.50 in a vector of 50000 elements

    CUDA kernel launch with 196 blocks of 256 threads
    CPU reference count: 24903

    Run 1: GPU count =      8 (WRONG)
    Run 2: GPU count =      1 (WRONG)
    Run 3: GPU count =      1 (WRONG)
    Run 4: GPU count =      1 (WRONG)
    Run 5: GPU count =      1 (WRONG)

    FAILED: a race condition is present!

9. Pass the race condition test by identifying the bug in the _countAboveThreshold_ CUDA kernel and solving it.
    team2@hclab02:~/Desktop/LPFH/gpu-programming$ nvcc race_condition_bug.cu -o race_condition && ./race_condition
    Counting elements > 0.50 in a vector of 50000 elements

    CUDA kernel launch with 196 blocks of 256 threads
    CPU reference count: 24903

    Run 1: GPU count =  24903 (ok)
    Run 2: GPU count =  24903 (ok)
    Run 3: GPU count =  24903 (ok)
    Run 4: GPU count =  24903 (ok)
    Run 5: GPU count =  24903 (ok)

    PASSED

## Wrap up and deliverables
1. Create blog post (or GitHub repo)
    https://github.com/LaurinPelz/gpu-programming
2. Describe main applications for GPUs (graphics and AI)
    Applications that need large quantities of parallel computing
3. Showcase your experiments and speed ups achieved
    Especially on larger datasets the difference between CPU and GPU computing times become apparent, the GPU is able to perform tasks much faster than the CPU, so long as the setup time doesn't exceed the actual calculation time.
4. Segway to architectural differences (describe CPU vs GPU during lab, cores, threads, and other specifics)
    
5. Showcase speed up experiments and describe differences (especially for today)
6. Discuss the race condition problem, how they might appear, and how they are usually treated.
7. Wrap up and conclude with what's next
