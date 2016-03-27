TARGETS=irclog.cma irclog.cmxa irclog.cmxs
INSTALL=$(addprefix _build/, $(TARGETS)) _build/irclog.cmi META

all:
	ocamlbuild -use-ocamlfind $(TARGETS)

clean:
	ocamlbuild -clean

install: all
	ocamlfind install irclog $(INSTALL)
