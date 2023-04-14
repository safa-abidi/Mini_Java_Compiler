%{
	

#include <stdio.h>	
#include "Semantic.c"

extern char *yytext;
char nom[256];

int yyerror(char const *msg);	
int yylex(void);
extern int yylineno;

%}

%token parenthese_ouvrante 
%token parenthese_fermante
%token accolade_ouvrante
%token accolade_fermante
%token crochet_ouvrant
%token crochet_fermant
%token point_virgule
%token virgule
%token point
%token VISIBILITE_PUBLIC
%token VISIBILITE_PROTECTED
%token VISIBILITE_PRIVATE
%token IF_KEYWORD
%token ELSE_KEYWORD
%token WHILE_KEYWORD
%token NEW_KEYWORD
%token THIS_KEYWORD
%token MAIN_KEYWORD
%token RETURN_KEYWORD
%token CLASS_KEYWORD
%token EXTENDS_KEYWORD
%token STATIC_KEYWORD
%token LENGTH_KEYWORD
%token AFFICHAGE
%token TYPE_INT
%token TYPE_BOOLEAN
%token TYPE_STRING
%token TYPE_VOID
%token Integer
%token IntegerNeg
%token Boolean
%token String
%token OP_AND
%token OP_OR
%token OP_PLUS
%token OP_MOINS
%token OP_MULTIPLICATION
%token OPP_AFFECT
%token OPP_NEG
%token OP_SUP
%token OP_SUP_EG
%token OP_INF
%token OP_INF_EG
%token OP_EG
%token OP_DIFF
%token Identifier
%token COMMENT_LINE
%token COMMENT_MULTI_LINE
%token EndOfFile

 
%error-verbose
%start Program

%%

Program	            :	MainClass classdec;

classdec            :   ClassDeclaration classdec | ;

MainClass	        :	CLASS_KEYWORD ID {checkIdentifier(nom, tOther ,class, yylineno);} accolade_ouvrante vardec VISIBILITE_PUBLIC  STATIC_KEYWORD TYPE_VOID MAIN_KEYWORD { checkIdentifier("main", tVoid, fonction, yylineno); } parenthese_ouvrante TYPE_STRING crochet_ouvrant crochet_fermant ID {checkIdentifier(nom, tString, parametre, yylineno);} parenthese_fermante accolade_ouvrante vardec stat accolade_fermante {fonctionEnd();}  accolade_fermante {classEnd();};

vardec              :   VarDeclaration vardec | ;

methoddec           : 	MethodDeclaration methoddec | ;

extend_key_id       : 	EXTENDS_KEYWORD ID | ;

ClassDeclaration	:	CLASS_KEYWORD ID {checkIdentifier(nom, tOther ,class, yylineno);} extend_key_id accolade_ouvrante vardec methoddec accolade_fermante {classEnd();}

VarDeclaration	    :	Type ID {checkIdentifier(nom, type ,variable , yylineno);} point_virgule
					|	error ID point_virgule            {yyerror (" Error : Type attendu en ligne : "); YYABORT}
					|	Type error point_virgule          {yyerror (" Error : Identifier attendu en ligne : "); YYABORT}
					|	Type ID error            		  {yyerror (" Error : Point virgule attendu en ligne : "); YYABORT};

virgule_type_ID :  virgule Type ID {checkIdentifier(nom, type ,variable , yylineno);} virgule_type_ID | ;

type_ID     : Type ID {checkIdentifier(nom, type ,variable , yylineno);} virgule_type_ID | ;

MethodDeclaration	:	VISIBILITE_PUBLIC Type ID {checkIdentifier(nom, type , fonction, yylineno);} parenthese_ouvrante {inParam();} type_ID {outParam();} parenthese_fermante accolade_ouvrante vardec stat RETURN_KEYWORD Expression point_virgule accolade_fermante {fonctionEnd();};

Type	            :	TYPE_INT crochet_ouvrant crochet_fermant {type=tInt} 
	                    |	TYPE_BOOLEAN {type=tBoolean}
	                    |	TYPE_INT {type=tInt}
						|	TYPE_STRING {type=tString};
	                    /*|	ID;*/

stat               : Statement stat | ;

Statement	        :	accolade_ouvrante stat accolade_fermante
	                |	IF_KEYWORD parenthese_ouvrante Expression parenthese_fermante Statement ELSE_KEYWORD Statement
	                |	WHILE_KEYWORD parenthese_ouvrante Expression parenthese_fermante Statement
	                |	AFFICHAGE parenthese_ouvrante Expression parenthese_fermante point_virgule
	                |	ID {verifierVarDeclared(nom, yylineno);} {useVar(nom);} OPP_AFFECT {initVar(nom, yylineno);} Expression {verifierTypeAffectation(nom, typeAffect, yylineno);} point_virgule
	                |	ID crochet_ouvrant Expression crochet_fermant {verifierVarDeclared(nom, yylineno)} {initVar(nom, yylineno);} {useVar(nom);} OPP_AFFECT Expression point_virgule;

op          : OP_AND | OP_INF | OP_PLUS | OP_MOINS | OP_MULTIPLICATION;

Expression	        :	Expression op Expression
	| 	Expression IntegerNeg {typeAffect = tInt;}
	|	Expression crochet_ouvrant Expression crochet_fermant
	|	Expression point LENGTH_KEYWORD {fonctionCallParameter(tInt, NULL, yylineno);} {typeAffect = tInt;}
	|	Expression point ID {fonctionCallStart(nom, type, yylineno);} {typeAffect = type;} parenthese_ouvrante expr parenthese_fermante {verifierFonctionArguments(yylineno);}
	|	Integer {fonctionCallParameter(tInt, NULL, yylineno);} {typeAffect = tInt;}
	|	Boolean {fonctionCallParameter(tBoolean, NULL, yylineno);} {typeAffect = tBoolean;}
	|	String {fonctionCallParameter(tString, NULL, yylineno);} {typeAffect = tString;}
	|	ID {(verifierVarDeclared(nom, yylineno));} {verifierVarInitialise(nom, yylineno);} {useVar(nom);} {fonctionCallParameter(tInt, nom, yylineno);} {typeAffect = type;}
	|	THIS_KEYWORD {fonctionCallParameter(tOther, NULL, yylineno);} {typeAffect = tOther;}
	|	NEW_KEYWORD TYPE_INT crochet_ouvrant Expression crochet_fermant 
	|	NEW_KEYWORD ID parenthese_ouvrante parenthese_fermante {fonctionCallParameter(tOther, NULL, yylineno);}
	|	OPP_NEG Expression {fonctionCallParameter(tBoolean, NULL, yylineno);} {typeAffect = tBoolean;}
	|	parenthese_ouvrante Expression parenthese_fermante;

virgule_expression  :   virgule Expression virgule_expression | ;

expr    :   Expression virgule_expression | ;

ID : Identifier;



%% 

int yyerror(char const *msg) {
       
	
	fprintf(stderr, "%s %d\n", msg,yylineno);
	exit(0);
	return 0;
	
	
}

extern FILE *yyin;

int main()
{
	table_global = NULL;
	table_local = NULL;
	table_total = NULL;
	actual_local = NULL;
	actual_global = NULL;
	type = tOther;
	isLocal =0;
	yyparse();
	printf("\n");
	endProgram();
	printf("\n");
	DisplaySymbolsTable(table_global);
	printf("\n");
	DisplaySymbolsTable(table_local);
	destructSymbolsTable(table_local);
	destructSymbolsTable(table_global);
 
}

  
                   
char *yyget_text(char *start) {
    size_t size =  1;
    char *text = malloc(size + 1);
    strncpy(text, start, size);
    text[size] = '\0';
    return text;
}