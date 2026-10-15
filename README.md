GPUs vs CPUs (lab 1: architecture and performance)

The goal of this lab is to develop a deeper understanding of the fundamental architectural differences between GPUs and CPUs and to observe how these differences impact performance.
Tasks (system info)

    GPU architecture: ...
    No. SMs: ...
    No. SPs: ...
    CPU: ...
    No. threads CPU vs no. threads GPU: ...

Tasks (performance)

    Compile and run addition
    Measure execution time GPU (hint: cudaEvent_t start, stop; \n cudaEventCreate(&start);)
    Implement CPU version
    Measure execution time CPU
    Compare CPU and GPU execution with changing block sizes (as low and as high, e.g., 512, 2048, so that you can gather performance trends) and data sizes (up to and including 50 billion)
    Plot measurements and speedups (block sizes and increasing data)
    Compile and run race condition exercise
    Pass the race condition test by identifying the bug in the countAboveThreshold CUDA kernel and solving it.

Wrap up and deliverables

    Create blog post (or GitHub repo)
    Describe main applications for GPUs (graphics and AI)
    Showcase your experiments and speed ups achieved
    Segway to architectural differences (describe CPU vs GPU during lab, cores, threads, and other specifics)
    Showcase speed up experiments and describe differences (especially for today)
    Discuss the race condition problem, how they might appear, and how they are usually treated.
    Wrap up and conclude with what's next
