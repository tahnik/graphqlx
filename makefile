.PHONY: test_parser

test_parser:
	ocamlbuild -Is src/language/src,src/language/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core parser_test.native

test_validate:
	ocamlbuild -Is src/language/src,src/validation/src,src/validation/test,lib/ocaml/prettify,lib/ocaml/dir -use-menhir -tag thread -use-ocamlfind -quiet -pkg core validate_.native