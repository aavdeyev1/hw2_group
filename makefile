CC=nvcc
CFLAGS=-I.
DEPS = pgmUtility.h pgmProcess.h 

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

imgRead: pgmUtility.o pgmProcess.o main.o
	nvcc -o imgRead gmUtility.o pgmProcess.o main.o -I. -lm -lpthread

clean:
	rm -r *.o imgRead
