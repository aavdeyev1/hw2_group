CC=nvcc
CFLAGS=-I.
DEPS = pgmUtility.h pgmProcess.h 

%.o: %.c $(DEPS)
	$(CC) -O2 -c -o $@ $< $(CFLAGS)

imRead: main.o pgmUtility.o pgmProcess.o
			nvcc -arch=sm_30 -o imRead pgmUtility.o pgmProcess.o main.o

main.o: main.cu
			nvcc -arch=sm_30 -c main.cu

pgmProcess.o: pgmProcess.cu
			nvcc -arch=sm_30 -c pgmProcess.cu

pgmUtility.o: pgmUtility.c pgmUtility.h
			g++ -c -x c++ pgmUtility.c -I.

clean:
			rm -r *.o lab1
