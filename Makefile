HOME = /home/ff/cs61c
UNAME = $(shell uname)

# running on hive machines
ifeq ($(UNAME),Linux)
CC = gcc -g -std=c99
GOTO = $(HOME)/bin/GotoBLAS2_Linux
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif

# running on 200 SD machines
ifeq ($(UNAME),Darwin)
CC = $(HOME)/bin/gcc-4.4.5/bin/gcc-61c -std=c99
GOTO = $(HOME)/bin/GotoBLAS2
GOTOLIB = $(GOTO)/libgoto2_nehalemp-r1.13.a
endif

INCLUDES = -I$(GOTO)
LIBS = -fopenmp  
# a pretty good flag selection for this machine...
CFLAGS = -msse4 -O3 -pipe -fopenmp

all:	bench-naive bench-small bench-all bench-openmp

# triple nested loop implementation
bench-naive: benchmark.o sgemm-naive.o
	$(CC) -o $@ $(LIBS) benchmark.o sgemm-naive.o $(GOTOLIB)

# your implementation for component 1
bench-small: benchmark.o sgemm-small.o
	$(CC) -o $@ $(LIBS) benchmark.o sgemm-small.o $(GOTOLIB)
# your implementation for component 2
bench-all: benchmark.o sgemm-all.o
	$(CC) -o $@ $(LIBS) benchmark.o sgemm-all.o $(GOTOLIB)
# your implementation for component 3
bench-openmp: benchmark.o sgemm-openmp.o
	$(CC) -o $@ $(LIBS) -fopenmp benchmark.o sgemm-openmp.o $(GOTOLIB)

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDES) $<

clean:
	rm -f bench-naive bench-small bench-all benchmark-openmp *.o
