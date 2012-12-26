%{ /* ISI@CAL */ 


#include "y.tab.h"
#include<stdio.h>
#include<string.h>

int intext = 0, incomment = 0, inmath = 0;
%}

ws  	[ \t]+
integer		[0-9]+
letters		[a-z]
punc            (\.|\,|\!|\?|\:|\;)
word		({punc}|[a-zA-Z0-9])+
special         (\%|\_|\&|\$|\#)
operator	("+"|"-"|"=")
%%

"\\\\" 			{printf(" %s \n", yytext);fflush(stdout); return(DBLBS);}
"\\"			{printf(" %s \n", yytext);fflush(stdout); return(BACKSL);}
"{"			{printf(" %s \n", yytext);fflush(stdout); return(LCURLYB);}
"}"			{printf(" %s \n", yytext);fflush(stdout); return(RCURLYB);}
"%"                     {printf(" %s \n", yytext);fflush(stdout); incomment = 1;}
"&"                     {printf(" %s \n", yytext);fflush(stdout); return(AMPERSAND);}
"$"                     {printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) inmath = 1;else inmath= 0; return(DOLLARMATH);}
"^"                     {printf(" %s \n", yytext);fflush(stdout); return(SUPERSCRIPT);}
"_"                     {printf(" %s \n", yytext);fflush(stdout); return(SUBSCRIPT);}
{special}		{printf(" %s \n", yytext);fflush(stdout); return(SPECCHAR);}
{operator}              {printf(" %s \n", yytext);fflush(stdout); yylval.arr = strdup(yytext); return(OPERATOR);}
"["			{printf(" %s \n", yytext);fflush(stdout); return(LSQRB);}
"]"			{printf(" %s \n", yytext);fflush(stdout); return(RSQRB);}
"\\begin{document}"     {printf(" %s \n", yytext);fflush(stdout); intext = 1;return(LBEGINDOCU);}
"\\end{document}"     {printf(" %s \n", yytext);fflush(stdout); intext = 0;return(LENDDOCU);}
"\\begin"			{printf(" %s \n", yytext);fflush(stdout); return(LBEGIN);}
"\\textbf"			{printf(" %s \n", yytext);fflush(stdout); return(BOLDFACE);}
"\\textit"			{printf(" %s \n", yytext);fflush(stdout); return(ITALICS);}
"\\hspace"			{printf(" %s \n", yytext);fflush(stdout); return(HSPACE);}
"\\vspace"			{printf(" %s \n", yytext);fflush(stdout); return(VSPACE);}
"\\documentclass"         {printf(" %s \n", yytext);fflush(stdout); return(DOCUMENTCLASS);}
"article"		{printf(" %s \n", yytext);fflush(stdout); return(ARTICLE);}
"proc"			{printf(" %s \n", yytext);fflush(stdout); return(PROC);}
"letter"		{printf(" %s \n", yytext);fflush(stdout); return(LETTER);}
"\\title"                 {printf(" %s \n", yytext);fflush(stdout); return(TITLE);}
"|"			{printf(" %s \n", yytext);fflush(stdout); return(PIPE);}
"\\end"			{printf(" %s \n", yytext);fflush(stdout); return(END);}
"section"		{printf(" %s \n", yytext);fflush(stdout); return(SECTION);}
"table"			{printf(" %s \n", yytext);fflush(stdout); return(TABLE);}
"tabular"		{printf(" %s \n", yytext);fflush(stdout); return(TABULAR);}
"vspace"		{printf(" %s \n", yytext);fflush(stdout); return(VSPACE);}
"\\hline"		{printf(" %s \n", yytext);fflush(stdout); return(HLINE);}
"b"			{printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) return(B); else {yylval.arr = strdup(yytext); return(LETTERS);}}
"c"			{printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) return(C); else {yylval.arr = strdup(yytext); return(LETTERS);}}
"h"			{printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) return(H); else {yylval.arr = strdup(yytext); return(LETTERS);}}
"l"			{printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) return(L); else {yylval.arr = strdup(yytext); return(LETTERS);}}
"r"			{printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) return(R); else {yylval.arr = strdup(yytext); return(LETTERS);}}
"t"			{printf(" %s \n", yytext);fflush(stdout); if(inmath == 0) return(T); else {yylval.arr = strdup(yytext); return(LETTERS);}}

"\\frac"		{printf(" %s \n", yytext);fflush(stdout); return(FRAC);}
"\\sqrt"		{printf(" %s \n", yytext);fflush(stdout); return(SQRT);}

{letters}		{printf(" %s \n", yytext);fflush(stdout); /* if(inmath == 1) */ yylval.arr = strdup(yytext); return(LETTERS);}
{integer}		{printf(" %s \n", yytext);fflush(stdout); /* if(incomment == 0) */ yylval.val = atoi(yytext); return(INTEGER);}
{word}			{printf(" %s \n", yytext);fflush(stdout); /* if(incomment == 0) */ yylval.arr = strdup(yytext); return(WORD);}
{ws}                    {/* printf(" %s \n", yytext);fflush(stdout);  return(WS); */}
"\\n"			{incomment = 0;}
%%
