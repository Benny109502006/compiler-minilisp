bison -d -o FIN.tab.c FIN.y
flex -o lex.yy.c FIN.l
gcc -c -g -I.. FIN.tab.c
gcc -c -g -I.. lex.yy.c
gcc lex.yy.o FIN.tab.o -ll -lm

