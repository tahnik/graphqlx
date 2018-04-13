.PHONY: test

test:
	ocamlbuild -Is src/parser,test/parser,test/prettify -use-menhir -tag thread -use-ocamlfind -quiet -pkg core fragment.native