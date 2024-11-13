#ifndef _TOKEN_HPP_
#define _TOKEN_HPP_

#include <iostream>
#include <string>

enum TokenType{ ERROR_T  , ID_T  , NUM_INT_T  , NOTYPE3  ,
		NUM_REAL_T  , ADDOP_T  , MULOP_T  , RELOP_T  ,
		NOTYPE8  , NOTYPE9  , NOTYPE10  ,
		ASSIGNOP_T  , NOTYPE12  ,
		AND_T  , NOTYPE14  ,
		OR_T  , SEMICOLON_T  , LBRACK_T  , RBRACK_T  , COMMA_T  ,
		RPAREN_T  , LPAREN_T  , NOT_T  ,
		EOF_T  ,
                VOID_T  , INT_T  , FLOAT_T  , BEGIN_T  , END_T  ,
                IF_T  , THEN_T  , ELSE_T  , WHILE_T};

class Token
{
private:
  int _type;
  std::string _value;
public:
  Token() : _type(ERROR_T), _value() {}
  Token(int type, const std::string &val): _type(type), _value(val) {} 

  int type() const {return _type;}
  int& type() {return _type;}

  const std::string& stype() const; 
  
  const std::string& value() const {return _value;}
  std::string& value() {return _value;}

  std::ostream& print(std::ostream &os) const;
};

std::ostream& operator<<(std::ostream &os, const Token &t);
    
#endif
