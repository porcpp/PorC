CC=gcc
FILES=sintatica.tab.c lex.yy.c c_templates.c
FLAGS=-ggdb


porcpp:
	bison -d sintatica.y
	flex lexical.l
	${CC} ${FILES} ${FLAGS} -o compiler

clean:
	rm *.tab.* *.yy.* compiler
