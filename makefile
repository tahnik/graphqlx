.PHONY: test_parser

test_parse:
	ocamlbuild -Is src/language/src,src/language/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core parser_.native

test_validate:
	ocamlbuild -Is src/language/src,src/validation/src,src/validation/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core validate_.native