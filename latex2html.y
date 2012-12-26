%{ /* ISI@CAL */ 

#include <stdio.h>
#include <ctype.h>
#include <string.h>

int yydebug = 1;
FILE *newHtml ;
int mathflag = 0;
int tablewidth = 0;

%}

%union 
{
  char*	arr;
	int	val;
}

%start latexstatement

%token  DBLBS    BACKSL    LCURLYB    RCURLYB    END	PIPE HLINE	AMPERSAND
%token  SPECCHAR LSQRB     RSQRB      LBEGIN      SECTION    TABLE	SUPERSCRIPT
%token  TABULAR  VSPACE    B          C           H          L		LETTERS
%token  T        R         DOCUMENTCLASS	SUBSCRIPT	DOLLARMATH	OPERATOR	
%token  ARTICLE  PROC      LETTER     TITLE       LBEGINDOCU  LENDDOCU
%token	SQRT	FRAC  BOLDFACE ITALICS	WS	HSPACE 	  VSPACE	

%type <arr> operand
%token <arr> WORD 
%token <arr> LETTERS
%token <arr> OPERATOR
%token <val> INTEGER

%%

latexstatement   :  documenttype{fprintf(newHtml,"<html> \n"); }  titletype LBEGINDOCU{fprintf(newHtml,"<body>\n"); }  mainbody {fprintf(newHtml,"</body>\n"); } LENDDOCU {fprintf(newHtml,"</html> \n"); }
                 ;

documenttype     :  DOCUMENTCLASS  LCURLYB  type  RCURLYB
		 ;

type		 :  ARTICLE
		 |  PROC
		 |  LETTER
		 ;

titletype        :  TITLE  LCURLYB {fprintf(newHtml,"<head> <title> "); } textoption  RCURLYB {fprintf(newHtml,"</title> </head>\n"); }
		 |
                 ;


mainbody         :  mainbody  mainoption
                 |  mainoption
                 ;

mainoption       :  formattedtextoption
		 |  tableoption
		 |  mathoption
                 ;

formattedtextoption:	BOLDFACE LCURLYB {fprintf(newHtml,"<b>\n");} formattedtextoption RCURLYB {fprintf(newHtml,"</b>\n");}
		   |    ITALICS LCURLYB {fprintf(newHtml,"<i>\n");} formattedtextoption RCURLYB {fprintf(newHtml,"</i>\n");}
		   |    textoption
		   ;


	

mathoption	 :  DOLLARMATH {fprintf(newHtml,"<math>\n");} {fprintf(newHtml,"<mrow>\n"); } mathstatement {fprintf(newHtml,"</mrow>\n"); } DOLLARMATH {fprintf(newHtml,"</math>\n");}
		 ;



mathstatement	 :  operand  OPERATOR {fprintf(newHtml,"<mo>%s</mo>\n",$2); }  mathstatement 
		 |  squareroot 
		 |  fractional
		 |  operand 
                 ;


fractional	 :  FRAC {fprintf(newHtml,"<mrow><mfrac>\n");} fracbody {fprintf(newHtml,"</mfrac></mrow>\n");}
		 ;

fracbody	 : fracpart fracpart
		 ;

fracpart	 : LCURLYB {fprintf(newHtml,"<mrow>\n"); } mathstatement {fprintf(newHtml,"</mrow>\n"); } RCURLYB
		 ;

squareroot	 : SQRT {fprintf(newHtml,"<msqrt>\n"); } LCURLYB mathstatement RCURLYB {fprintf(newHtml,"</msqrt>\n"); }
		 ;

operand		 : LETTERS SUPERSCRIPT {fprintf(newHtml,"<mrow><msup>\n<mi>%s</mi>",$1); } operand {fprintf(newHtml,"</msup></mrow>");}
		 | INTEGER SUPERSCRIPT {fprintf(newHtml,"<mrow><msup>\n<mn>%d</mn>",$1); } operand {fprintf(newHtml,"</msup></mrow>");}
		 | LETTERS SUBSCRIPT {fprintf(newHtml,"<mrow><msub>\n<mi>%s</mi>",$1); } operand {fprintf(newHtml,"</msub></mrow>");}
		 | INTEGER SUBSCRIPT {fprintf(newHtml,"<mrow><msub>\n<mn>%d</mn>",$1); } operand {fprintf(newHtml,"</msub></mrow>");}
		 | LETTERS {fprintf(newHtml,"<mi>%s</mi>",$1); }  
		 | INTEGER {fprintf(newHtml,"<mn>%d</mn>",$1); }
		 ;



tableoption	 :  starttable tablebody endtable
		 ;

starttable	 :  LBEGIN LCURLYB TABLE RCURLYB LSQRB position RSQRB
		 ;

position 	 : T
		 | H
		 | B
		 ;
		
tablebody	 : starttabular tabularbody endtabular tablebody
		 | starttabular tabularbody endtabular
		 ;

starttabular	 : LBEGIN LCURLYB TABULAR RCURLYB LCURLYB tablespec RCURLYB {fprintf(newHtml,"<table border=\"%d\">\n",tablewidth); }
		 ;

endtabular	 : END LCURLYB TABULAR RCURLYB {fprintf(newHtml,"</table>\n"); tablewidth = 0; }
		 ;

endtable	 : END LCURLYB TABLE RCURLYB
		 ;

tabularbody	 : hline {fprintf(newHtml,"<tr>\n<td> "); } row tabularbody
		 | hline
		 ;

hline		 : HLINE hline
		 |
		 ;

row		 : tabletextoption AMPERSAND {fprintf(newHtml," </td> <td>"); } row
		 | tabletextoption DBLBS {fprintf(newHtml," </td>\n</tr>\n"); }
		 ;

tablespec	 : tablespec colspec 
		 | colspec
		 ;

colspec		 : L
		 | C
		 | R
		 | PIPE {tablewidth = 1;}
		 ;


tabletextoption  :  tabletextoption WORD {fprintf(newHtml," %s",$2);} 
		 |  tabletextoption INTEGER {fprintf(newHtml," %d",$2);}
                 |  WORD {fprintf(newHtml,"%s",$1); }
		 |  INTEGER {fprintf(newHtml,"%d",$1); }
		 ;

textoption       :  textoption WORD {fprintf(newHtml," %s",$2);} 
		 |  textoption INTEGER {fprintf(newHtml," %d",$2);}
                 |  WORD {fprintf(newHtml,"%s",$1); }
		 |  INTEGER {fprintf(newHtml,"%d",$1); }
		 |  textoption DBLBS {fprintf(newHtml,"<br/>"); }
		 |  textoption HSPACE {fprintf(newHtml,"&nbsp;"); }
		 |  textoption VSPACE {fprintf(newHtml,"<br/>"); }
		 ;

%%

int main(){
	newHtml = fopen("created.html","w+");
	return yyparse();
	}

int yyerror (char *msg) {
	return fprintf (stderr, "YACC: %s\n", msg);
	}
