CC=gcc
SIMBOL_TABLE_FILES=lib/simbol_table/variable.c lib/simbol_table/node.c lib/simbol_table/simbol_table.c
TEMPLATE_FILES=lib/templates/c_templates.c lib/templates/verify_templates.c lib/templates/transform_types.c
UTIL_FILES=lib/util/log.c
LIB=${TEMPLATE_FILES} ${SIMBOL_TABLE_FILES} ${UTIL_FILES}
FILES=sintatica.tab.c lex.yy.c ${LIB}
FLAGS=-ggdb
TESTS=tests/simple_mocks.c tests/transform_types_test.c tests/variable_test.c tests/node_test.c tests/simbol_table_test.c tests/main_test.c


porc:
	bison -d sintatica.y
	flex lexical.l
	${CC} ${FILES} ${FLAGS} -o compiler


lib_tests:
	${CC} ${TESTS} ${LIB} -ggdb -o execute_tests


clean:
	rm -f *.tab.* *.yy.* ./compiler ./execute_tests *.log *~
