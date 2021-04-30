
REPO = https://github.com/math-comp/math-comp.git
TAG = mathcomp-1.12.0
WORKDIR = workdir

SUBPKGS = ssreflect fingroup character field solvable algebra all

.PHONY: all get

all: $(WORKDIR)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 --no-checkout -b $(TAG) $(REPO) $(WORKDIR)
	( cd $(WORKDIR) && git checkout $(TAG) && git apply ../mathcomp-fast-load.patch )
	cp -r dune-files/* $(WORKDIR)/

install:
	dune install ${addprefix coq-mathcomp-, ssreflect fingroup algebra solvable field character}
