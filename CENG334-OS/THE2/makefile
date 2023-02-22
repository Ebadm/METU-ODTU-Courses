all: hw2
hw2: hw2.o hw2_output.o
	g++ -pthread hw2.o -o hw2
hw2.o: hw2.cpp
	g++ -pthread -c hw2.cpp

hw2_output.o: hw2_output.c hw2_output.h
	gcc -c hw2_output.c
clean:
	rm *.o hw2

