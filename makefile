.PHONY: test_parser

test_parser:
	ocamlbuild -Is src/parser,test/parser,lib/prettify -use-menhir -tag thread -use-ocamlfind -quiet -pkg core parser_.native