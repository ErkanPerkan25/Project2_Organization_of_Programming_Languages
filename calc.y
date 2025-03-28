/********************************************
* Author: Eric Hansson 
* Date: 11/19/2024
* Purpose: To use to create grammar and give it
meaning. It will count globar variables, local
variables, if statements, while statements.
It will print also out the functions and their 
local variables, if statements and while statements

*********************************************/
%{
#include <iostream>
#include <FlexLexer.h>

// don't necessarily need this all the time - this code uses some
// custom functions ...
#include "MyMemory.hpp"

// defines my lexical analyzer class
#include "MyScanner.hpp"

// bison/yacc requires a function called yylex() to get the next token
#define yylex(x) scanner->lex(x)

using namespace yy;
using namespace std;

int globalVars = 0;
int localVars = 0;
int varCount = 0;
int ifCount = 0;
int whileCount = 0;
string funcName = "";

%}

%require "3.2"
%language "C++"

%defines "Parser.hpp"
%output "Parser.cpp"
%define api.parser.class {Parser}


%code requires
{

struct myst
{
  int ival; 
  double dval;
  std::string sval;
};

}
%define api.value.type {struct myst}

%parse-param {MyScanner* scanner}


/* bison token  Declarations */
%token ADDOP_T
%token ASSIGNOP_T
%token ID_T
%token LPAREN_T
%token RPAREN_T
%token MULOP_T
%token NUM_INT_T
%token NUM_REAL_T
%token SEMICOLON_T
%token RELOP_T
%token LBRACK_T
%token RBRACK_T

%token INT_T
%token FLOAT_T
%token VOID_T
%token BEGIN_T
%token END_T
%token WHILE_T
%token AND_T
%token OR_T
%token NOT_T
%token COMMA_T
%token IF_T
%token THEN_T
%token ELSE_T

%token EOF_T


// if grammar allows multiple interpretations of an expr,
//   these can help ...
//  consider  5-4-3 ... is it 
//      (5-4)-3  (%left)  or
//      5-(4-3)  (%right)   
//  note that the grammar below already automatically forces the first option above
%left ADDOP_T
%left MULOP_T

/* Grammar follows */
%%
start: pgm
    { 
        // Prints out the global variables
        cout << "The program contains " << globalVars << " global variable declarations" << endl;
    }
     ;

pgm: pgmpart
   pgm 
   | 
   pgmpart;

pgmpart: vardecl
       { 
        // counting the global variables, and resets the variable count
        globalVars += varCount;
        varCount = 0;
       }
       | 
       function
       {
        // Sets the local variables, and then prints all the information of the function
        localVars = varCount;
        cout << "Function: " << $$.sval << " contatins:" << endl;
        cout << "*  local variables: " << localVars << endl;
        cout << "*    if statements: " << ifCount << endl;
        cout << "* while statements: " << whileCount << endl;
        // Resets the values for the next function
        varCount = 0;
        localVars = 0; 
        ifCount = 0;
        whileCount = 0;
       }
       ;

vardecl: type varlist SEMICOLON_T
       {
        $$.dval = $2.dval;
       };

type: INT_T
    |
    FLOAT_T
    |
    VOID_T
    ;

varlist: ID_T COMMA_T varlist
       {        
        //  varibale count 
        varCount++;
        $$.dval = varCount;
       }
       |
       ID_T
       {
        // counts the last variable in the declaration
        varCount++;
        $$.dval = varCount;
       }
       ;


function: type ID_T LPAREN_T RPAREN_T body
        {
            // gets the function name
            $$.sval = $2.sval;
        }
        |
        type ID_T LPAREN_T fplist RPAREN_T body
        {
            // gets the function name
            $$.sval = $2.sval;
        }
        ;

body: BEGIN_T bodylist END_T;

fplist: ID_T COMMA_T fplist
      {
        // Counts the parameters in a function as local variables
        varCount++;
      }
      |
      ID_T
      {
        // Counts the parameters in a function as local variables
        varCount++;
      }
      ;

bodylist: vardecl bodylist
        {
        }
        | 
        stmt bodylist
        | /*epsilon*/;

stmt: assign SEMICOLON_T 
    |
    fcall SEMICOLON_T
    |
    while
    {
        // Add one to the while statements count
        whileCount++;
    }
    |
    if
    {
        // Add one to the if statements count
        ifCount++; 
    }
    |
    body
    ;

assign: ID_T ASSIGNOP_T expr
      {
        // stores a values to a variable
        storeValue($1.sval, $3.dval);
      }
      ;

expr: factor
    {
        $$.dval = $1.dval;    
    }
    |
    expr ADDOP_T factor
    {
        // does addition or subtraction
        if($2.sval == "+")
            $$.dval = $1.dval + $3.dval;
        else
            $$.dval = $1.dval - $3.dval;
    }
    ;

factor: term
      {
        $$.dval = $1.dval;
      }
      |
      factor MULOP_T term
      {
        // does multiplication or division
        if($2.sval == "*")
            $$.dval = $1.dval * $3.dval;
        else
            $$.dval = $1.dval / $3.dval;
      }
      ;

term: ID_T 
    {
        // checks what is stored in a variable
        $$.dval = lookupValue($1.sval);
    } 
    | 
    NUM_INT_T
    {
        $$.dval = $1.ival;
    }
    |
    NUM_REAL_T
    {
        $$.dval = $1.dval;
    }
    |
    LPAREN_T expr RPAREN_T 
    {
        $$.dval = $2.dval;
    }
    |
    ADDOP_T term 
    {
        // checks if a number is negative or positive
        if($1.sval == "-"){
            $$.dval = - $2.dval;
        }
        else{
            $$.dval = $2.dval;
        }
    }
    |
    fcall
    {
        $$.dval = $1.dval; 
    }
    ;

bexpr: bfactor
     | 
     bexpr OR_T bfactor
     ;

bfactor: bneg
       |
       bfactor AND_T bneg
       ;

bneg: bterm
    |
    NOT_T bterm
    ;

bterm: expr RELOP_T expr
     |
     LPAREN_T bterm RPAREN_T
     ;

fcall: ID_T LPAREN_T RPAREN_T
     |
     ID_T LPAREN_T aplist RPAREN_T
     ;

aplist: expr COMMA_T aplist
      |
      expr
      ;

while: WHILE_T LPAREN_T bexpr RPAREN_T stmt
     {
     }
     ;

if: IF_T LPAREN_T bexpr RPAREN_T THEN_T stmt
  |
  IF_T LPAREN_T bexpr RPAREN_T THEN_T stmt ELSE_T stmt
  ;

%%

// Gives a error message when it does not recognize a input
void Parser::error(const std::string& msg) {
    std::cerr << msg << " near " << scanner->YYText()  
              << " on line #" << scanner->lineno()
              << endl;
}
