#include "language.h"


unsigned int current_language = ENGLISH;

void SetLanguage(unsigned int language)
{
    current_language = language;
}

unsigned int GetLanguage()
{
    return current_language;
}

unsigned char * GetStr(unsigned int str_no)
{ 
    return (unsigned char *)strings[str_no].text[GetLanguage()];
}