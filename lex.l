/******************************************************************
* Author: Eric Hansson
* File: lex.l
* Date: 11/11/2024
* Purpose: This code is used to look for valid tokens which is then
associted with the tokens correct type.
*******************************************************************/
%{
#include <iostream>
#include "MyScanner.hpp"
#include "Parser.hpp"
#define YY_DECL int MyScanner::lex(Parser::semantic_type *yylval)

using namespace yy;
using namespace std;
%}

%option c++ noyywrap yylineno
%option outfile="MyScanner.cpp"
%option nounistd

DIGIT       [0-9]
ALPHA       [A-Za-z]
WSPACE      [\ \t\n]

%%
<<EOF>>                 {return Parser::token::YYEOF;}
"void"                  {return Parser::token::VOID_T;}    /*Keyword for void, rc 24*/
"int"                   {return Parser::token::INT_T;}    /*Keyword for int, rc 25*/
"float"                 {return Parser::token::FLOAT_T;}    /*Keyword for float, rc 26*/
"begin"                 {return Parser::token::BEGIN_T;}    /*Keyword for begin, rc 27*/
"end"                   {return Parser::token::END_T;}    /*Keyword for end, rc 28*/
"if"                    {return Parser::token::IF_T;}    /*Keyword for if, rc 29*/
"then"                  {return Parser::token::THEN_T;}    /*Keyword for then, rc 30*/
"else"                  {return Parser::token::ELSE_T;}    /*Keyword for else, rc 31*/
"while"                 {return Parser::token::WHILE_T;}    /*Keyword for whilie, rc 32*/


{ALPHA}({ALPHA}|{DIGIT})* {
                    yylval->sval=YYText();
                    return Parser::token::ID_T;}

{DIGIT}+                {
                        int x = stoi(YYText());
                        yylval->ival=x;
                        return Parser::token::NUM_INT_T;}

{DIGIT}+\.{DIGIT}+      {
                        double x = stod(YYText());
                        yylval->dval=x;
                        return Parser::token::NUM_REAL_T;}

"+"|"-"                 {yylval->sval = YYText(); return Parser::token::ADDOP_T;}     /*Expression for Tokens of type ADDOP_T*/
"*"|'/'                 {yylval->sval = YYText(); return Parser::token::MULOP_T;}     /*Expression for Tokens of type MULTOP_T*/
">"|"<"|"=="|"<="|">="  {return Parser::token::RELOP_T;}
"<-"                    {return Parser::token::ASSIGNOP_T;}    /*Expression for Tokens of type ASSIGNOP_T*/
"&&"                    {return Parser::token::AND_T;}    /*Expression for Tokens of type AND_T*/
"||"                    {return Parser::token::OR_T;}    /*Expression for Tokens of type OR_T*/
";"                     {return Parser::token::SEMICOLON_T;}    /*Expression for Tokens of type SEMICOLON_T*/
"["                     {return Parser::token::LBRACK_T;}    /*Expression for Tokens of type LBRACK_T*/
"]"                     {return Parser::token::RBRACK_T;}    /*Expression for Tokens of type RBRACK_T*/
","                     {return Parser::token::COMMA_T;}    /*Expression for Tokens of type COMMA_T*/
"("                     {return Parser::token::LPAREN_T;}    /*Expression for Tokens of type LPAREN_T*/
")"                     {return Parser::token::RPAREN_T;}    /*Expression for Tokens of type RPAREN_T*/
"~"                     {return Parser::token::NOT_T;}    /*Expression for Tokens of type NOT_T*/

{WSPACE}+               {}

#.*\n                     {}    /*Expression for comments*/

.                       { std::cerr << "UNMATECHED CHARACTER: '" << yytext[0]
                            << "' on line " << yylineno << std::endl;}
%%
