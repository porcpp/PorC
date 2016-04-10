porcpp:
		bison -d sintatica.y
		flex lexical.l
		gcc sintatica.tab.c lex.yy.c

clean:
		rm *.tab.* *.yy.* *.out
