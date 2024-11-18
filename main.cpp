/******************************************************
* Author: Eric Hansson
* Date: 11/24/2024
* Purpose: To parse code that is provided by input file
* or by using the command line.
*****************************************************/
#include <FlexLexer.h>
#include <fstream>
#include <iostream>

#include "MyScanner.hpp"
#include "Parser.hpp"

using namespace yy;
using namespace std;

int yyFlexLexer::yylex() {
    // this call should never happen, but flex/bison requires its implementation
    throw std::runtime_error("Bad call to yyFlexLexer::yylex()");
}

int main(int argc, char ** argv)
{
    // If there is no file provided, read from the command line
    if (!argv[1]) {
        MyScanner scanner(cin,cerr);
        Parser parser(&scanner);
        parser.parse();
    }
    // Read the file and parse it
    else{
        ifstream ifile(argv[1]);

        MyScanner scanner(ifile, cerr);
        Parser parser(&scanner);
        parser.parse();
    }

    return 0;
}
