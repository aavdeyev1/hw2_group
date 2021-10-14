NVCC = /usr/local/cuda/bin/nvcc
CXX = g++

# here are all the objects
GPUOBJS = pgmProcess.o pgmUtility.o 
OBJS = main.o

imRead: $(OBJS) $(GPUOBJS)
		$(NVCC) -arch=sm_30 -o imRead $(OBJS) $(GPUOBJS) 

main.o: main.c
		$(CXX) -c main.c

pgmProcess.o: pgmProcess.cu
		$(NVCC) -arch=sm_30 -c pgmProcess.cu

pgmUtility.o: pgmUtility.c pgmUtility.h
		$(CXX) -c -x c++ pgmUtility.c -I.

clean:
	rm -f *.o
	rm -f imRead


# Build tools
# NVCC = /usr/local/cuda/bin/nvcc
# CXX = g++

# # here are all the objects
# GPUOBJS = vecAdd.o hostFun.o 
# OBJS = main.o

# # make and compile
# myVec:$(OBJS) $(GPUOBJS)
# 	$(NVCC) -arch=sm_30 -o myVec $(OBJS) $(GPUOBJS) 

# vecAdd.o: vecAdd.cu
# 	$(NVCC) -arch=sm_30 -c vecAdd.cu 

# hostFun.o: hostFun.cu
# 	$(NVCC) -arch=sm_30 -c hostFun.cu

# main.o: main.c
# 	$(CXX) -c main.c

# clean:
# 	rm -f *.o
# 	rm -f myVec