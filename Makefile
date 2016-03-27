TARGETS=irclog.cma irclog.cmxa irclog.cmxs irclog.a
INSTALL=$(addprefix _build/, $(TARGETS)) _build/irclog.cmi META

all:
	ocamlbuild -use-ocamlfind $(TARGETS)

TOOLS=tools/stats.native

tools: all
	ocamlbuild -use-ocamlfind -package containers -package irclog -package unix $(TOOLS)

clean:
	ocamlbuild -clean

install: all
	ocamlfind install irclog $(INSTALL)
