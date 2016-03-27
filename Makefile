TARGETS=irclog.cma irclog.cmxa irclog.cmxs irclog.a
INSTALL=$(addprefix _build/, $(TARGETS)) _build/irclog.cmi META

all: lib tools

lib:
	ocamlbuild -use-ocamlfind $(TARGETS)

TOOLS=tools/stats.native
TOOLS_DEPS=-package containers -package unix -package re.posix -package sequence

tools: lib
	ocamlbuild -use-ocamlfind -I . $(TOOLS_DEPS) $(TOOLS)

clean:
	ocamlbuild -clean

install: all
	ocamlfind install irclog $(INSTALL)
