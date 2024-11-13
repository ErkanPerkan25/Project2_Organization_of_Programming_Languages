#include "Token.hpp"

using namespace std;

static string TokenStrings[] =
  {"ERROR_T" ,"ID_T" ,"NUM_INT_T" ,"ERROR_T" ,
   "NUM_REAL_T" ,"ADDOP_T" ,"MULOP_T" ,"RELOP_T" ,
   "RELOP_T" ,"ERROR" ,"RELOP_T" ,
   "ASSIGNOP_T" ,"ERROR" ,
   "AND_T" ,"ERROR" ,
   "OR_T" ,"SEMICOLON_T" ,"LBRACK_T" ,"RBRACK_T" ,"COMMA_T" ,
   "RPAREN_T" ,"LPAREN_T" ,"NOT_T" ,
   "EOF_T" , 
   "VOID_T" ,"INT_T" ,"FLOAT_T" ,"BEGIN_T" ,"END_T" ,
   "IF_T" ,"THEN_T" ,"ELSE_T" ,"WHILE_T"};


const string&
Token::stype() const
{
  return TokenStrings[_type];
}

std::ostream&
Token::print(ostream &os) const
{
  os << TokenStrings[_type]
     << '\t'
     << '\"' << _value << '\"';
  return os;
}

std::ostream& operator<<(std::ostream &os, const Token &t)
{
  return t.print(os);
}
