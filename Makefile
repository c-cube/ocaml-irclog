TARGETS=irclog.cma irclog.cmxa irclog.cmxs
INSTALL=$(TARGETS) irclog.cmi META

all:
	ocamlbuild -use-ocamlfind $(TARGETS)

clean:
	ocamlbuild -clean

install: all
	ocamlfind install irclog $(INSTALL)
