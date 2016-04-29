CC=gcc
SIMBLE_TABLE_FILES=lib/simbol_table/variable.c lib/simbol_table/node.c lib/simbol_table/simbol_table.c 
TEMPLATE_FILES=lib/templates/c_templates.c lib/templates/verify_templates.c
LIB=${TEMPLATE_FILES} ${SIMBLE_TABLE_FILES}
FILES=sintatica.tab.c lex.yy.c ${LIB}
FLAGS=-ggdb
TESTS=tests/variable_test.c tests/node_test.c tests/simbol_table_test.c tests/main_test.c


porcpp:
	bison -d sintatica.y
	flex lexical.l
	${CC} ${FILES} ${FLAGS} -o compiler


lib_tests:
	${CC} ${TESTS} ${LIB} -ggdb -o execute_tests


clean:
	rm -f *.tab.* *.yy.* ./compiler ./execute_tests
