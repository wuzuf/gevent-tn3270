all: src/ext/_tn3270_parser.c src/ext/_parser.c

src/ext/_tn3270_parser.c: src/ext/_tn3270_parser.rl
	ragel src/ext/_tn3270_parser.rl

src/ext/_parser.c: src/ext/_parser.pyx
	cython src/ext/_parser.pyx
