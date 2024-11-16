CXX ?= g++
LEX ?= flex++
BISON ?= bison

CXXFLAGS := -c -Wall -ansi -pedantic -std=c++20

p2sol: main.o Parser.o MyScanner.o MyMemory.o
	$(CXX) -o p2sol main.o Parser.o MyScanner.o MyMemory.o

main.o: main.cpp Parser.hpp MyScanner.hpp
	$(CC) $(CXXFLAGS) main.cpp

Parser.o: Parser.cpp Parser.hpp MyScanner.hpp
	$(CC) $(CXXFLAGS) Parser.cpp

MyScanner.o: MyScanner.cpp Parser.hpp MyScanner.hpp
	$(CC) $(CXXFLAGS) MyScanner.cpp

MyScanner.cpp: lex.l MyScanner.hpp
	$(LEX) lex.l

Parser.hpp: calc.y MyScanner.hpp
	$(BISON) calc.y

Parser.cpp: calc.y MyScanner.hpp
	$(BISON) calc.y

MyMemory.o: MyMemory.cpp MyMemory.hpp
	$(CC) $(CXXFLAGS) MyMemory.cpp

clean:
	/bin/rm -f *~ *.o p2sol Parser.cpp Parser.hpp MyScanner.cpp

.PHONY: clean
