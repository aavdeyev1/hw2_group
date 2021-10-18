NVCC = /usr/local/cuda/bin/nvcc
CXX = g++

# here are all the objects
GPUOBJS = pgmProcess.o pgmUtility.o pgmUtilityGPU.o
OBJS = main.o

imRead: $(OBJS) $(GPUOBJS)
		$(NVCC) -arch=sm_30 -o imRead $(OBJS) $(GPUOBJS) 

pgmProcess.o: pgmProcess.cu pgmProcess.h
		$(NVCC) -arch=sm_30 -c pgmProcess.cu

pgmUtility.o: pgmUtility.c pgmUtility.h
		$(CXX) -c -x c++ pgmUtility.c -I.

pgmUtilityGPU.o: pgmUtilityGPU.cu pgmUtility.h
		$(NVCC) -arch=sm_30 -c pgmUtilityGPU.cu

main.o: main.cu
		$(NVCC) -arch=sm_30 -c main.cu

clean:
	rm -f *.o
	rm -f imRead
