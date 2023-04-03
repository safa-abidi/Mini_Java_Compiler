%{	
 #include <stdio.h>	
 #include <stdlib.h>		
 #include "TP2.tab.h"	                                                                         	
 			
%}

%option yylineno
delim     [ \t]
bl        {delim}+
chiffre   [0-9]
lettre    [a-zA-Z]
id        ({lettre}|"_")({lettre}|{chiffre}|"_")*
int       {chiffre}+
intneg    ("-")?{chiffre}+
boolean   (true|false)
String    \"([^\"\\]|\\.)*\"
iderrone  {chiffre}({lettre}|{chiffre})*
par_ouvrante  (\()
par_fermante  (\))
acc_ouvrante "{"
acc_fermante "}"
croch_ouvrant "["
croch_fermant "]"
point_virgule ;
virgule ,
point (\.)
superieur >
superieur_egale >=
inferieur <
inferieur_egale <=
egale ==
different !=
plus (\+)
moins "-"
multiplication (\*)
and &&
or (\|\|)
neg !
affect =
COMMENT_LINE        "//".*
COMMENT   "/*"([^*]|\*+[^*/])*\*+"/"

%%

{bl}                                         /* pas d'actions */
"\n" 		                              //++yylineno;
{par_ouvrante}                               return parenthese_ouvrante;
{par_fermante}                               return parenthese_fermante;
{acc_ouvrante}                               return  accolade_ouvrante;
{acc_fermante}                               return  accolade_fermante;
{croch_ouvrant}                              return  crochet_ouvrant;
{croch_fermant}                              return  crochet_fermant;
{point_virgule}                              return  point_virgule;
{virgule}                                    return virgule;
{point}                                      return  point;

"public"                                     return  VISIBILITE_PUBLIC;
"protected"                                  return  VISIBILITE_PROTECTED;
"private"                                    return  VISIBILITE_PRIVATE;

"if"                                         return  IF_KEYWORD;
"else"                                       return  ELSE_KEYWORD;
"while"                                      return  WHILE_KEYWORD;
"new"                                        return  NEW_KEYWORD;
"this"                                       return  THIS_KEYWORD;
"main"                                       return  MAIN_KEYWORD;
"return"                                     return  RETURN_KEYWORD;
"class"                                      return  CLASS_KEYWORD;
"extends"                                    return  EXTENDS_KEYWORD;
"static"                                     return  STATIC_KEYWORD;
"length"                                     return  LENGTH_KEYWORD;

"System.out.println"                         return  AFFICHAGE;

"int"                                        return  TYPE_INT;
"boolean"                                    return  TYPE_BOOLEAN;
"String"                                     return  TYPE_STRING;
"void"                                       return  TYPE_VOID;

{id}                                         return  Identifier;

{int}                                        return  Integer;
{intneg}                                     return  IntegerNeg;
{boolean}                                    return  Boolean;
{String}                                     return  String;

{and}                                        return  OP_AND;
{or}                                         return  OP_OR;
{plus}                                       return  OP_PLUS;
{moins}                                      return  OP_MOINS;
{multiplication}                             return  OP_MULTIPLICATION;
{affect}	                                   return  OPP_AFFECT;
{neg}                                        return  OPP_NEG;

{superieur}                                  return  OP_SUP;
{superieur_egale}                            return  OP_SUP_EG;
{inferieur}                                  return  OP_INF;
{inferieur_egale}                            return  OP_INF_EG;
{egale}                                      return  OP_EG;
{different}                                  return  OP_DIFF;



{COMMENT_LINE}         		               printf(" COMMENT_LINE ");   
{COMMENT}                                    printf(" COMMENT_MULTI_LINE ")  ;                          

<<EOF>>                                      return EOF;

{iderrone}              {fprintf(stderr,"illegal identifier \'%s\' on line :%d\n",yytext,yylineno);}

.                       {fprintf(stderr,"invalid input \'%s\' on line :%d\n", yytext, yylineno);}
	

%%

int yywrap()
{
	return(1);
}
