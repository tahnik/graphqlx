.PHONY: test_parser

test_parse:
	ocamlbuild -Is language/src,language/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core parser_.native

test_validate:
	ocamlbuild -Is language/src,validation/src,validation/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core validate_.native