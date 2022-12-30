test : scanner.o parser.o
	gcc scanner.o parser.o -o compilador -lfl -lm

parser.o : parser.c parser.h
	gcc -c parser.c

scanner.o : scanner.c archivo.h
	gcc -c scanner.c

scanner.c scanner.h : scanner.l 
	flex scanner.l

parser.c parser.h : parser.y
	bison parser.y

clean : 
	rm parser.c parser.h parser.o scanner.c scanner.h scanner.l compilador