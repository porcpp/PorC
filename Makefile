CC=gcc
LIB=lib/templates/c_templates.c
FILES=sintatica.tab.c lex.yy.c ${LIB}
FLAGS=-ggdb


porcpp:
	bison -d sintatica.y
	flex lexical.l
	${CC} ${FILES} ${FLAGS} -o compiler

clean:
	rm *.tab.* *.yy.* compiler
