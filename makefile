image_edit: main.o pgmProcess.o
	nvcc -arch=sm_52 -o lab1 main.o pgmProcess.o  -I.

main.o: main.cu
	nvcc -arch=sm_52 -c main.cu

pgmProcess.o: pgmProcess.cu pgmProcess.h
	g++ -c -o pgmProcess.o pgmProcess.cu -I.


pgmUtility.o: pgmUtility.c pgmUtility.h
	g++ -c -o pgmUtility.o pgmUtility.c -I.

clean:
	rm -r *.o image_edit
