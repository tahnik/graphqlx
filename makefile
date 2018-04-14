.PHONY: test_parser

test_parser:
	ocamlbuild -Is language/src,language/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core parser_.native