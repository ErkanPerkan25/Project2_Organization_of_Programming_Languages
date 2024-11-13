CC = g++ -c -Wall -ansi -pedantic -std=c++20 
LN = g++

mycalc: main.o Parser.o MyScanner.o
	$(LN) -o mycalc main.o Parser.o MyScanner.o 

main.o: main.cpp Parser.hpp MyScanner.hpp
	$(CC) main.cpp

Parser.o: Parser.cpp Parser.hpp MyScanner.hpp
	$(CC) Parser.cpp

MyScanner.o: MyScanner.cpp Parser.hpp MyScanner.hpp
	$(CC) MyScanner.cpp

MyScanner.cpp: lex.l MyScanner.hpp
	flex++ lex.l

Parser.hpp: calc.y MyScanner.hpp
	bison calc.y

Parser.cpp: calc.y MyScanner.hpp
	bison calc.y

clean:
	/bin/rm -f *~ *.o mycalc Parser.cpp Parser.hpp MyScanner.cpp
