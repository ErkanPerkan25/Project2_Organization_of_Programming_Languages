#ifndef _MY_MEMORY_HPP_
#define _MY_MEMORY_HPP_

#include <string>

double lookupValue(std::string &varName);
void storeValue(std::string &varName, double value);

void varCount();
int getVarCount();
void clearVarCount();

std::string getFuncName(std::string &varName);
void funcResult();
void result();


#endif
