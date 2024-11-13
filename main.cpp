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
    ifstream ifile(argv[1]);

    MyScanner scanner(ifile, cerr);
    Parser parser{&scanner};
    parser.parse();

    return 0;
}
