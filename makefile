.PHONY: test

test:
	ocamlbuild -Is src/parser,test/parser -use-menhir -tag thread -use-ocamlfind -quiet -pkg core test.native