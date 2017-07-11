# Makefile

hello: main.o hello.o
	gcc -g  -o hello main.o hello.o

main.o: main.c
	gcc -c main.c

hello.o: hello.c
	gcc -c hello.c

clean:
	rm -f *.o hello
