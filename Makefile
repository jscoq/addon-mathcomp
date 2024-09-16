REPO = https://github.com/math-comp/math-comp.git
TAG = mathcomp-1.19.0
WORKDIR = workdir

# Regular package set
# SUBPKGS = ssreflect fingroup algebra field solvable character

# Reduced pkg set for jsCoq 2.0 development
SUBPKGS = ${addprefix coq-mathcomp-,ssreflect fingroup algebra}
# This needs to be a comma-separated list damn
SUBPKGS_BUILD = coq-mathcomp-ssreflect,coq-mathcomp-fingroup,coq-mathcomp-algebra

# Git boilerplate
define GIT_CLONE_COMMIT
mkdir -p $(WORKDIR) && cd $(WORKDIR) && git init && \
git remote add origin $(REPO) && \
git fetch --depth=1 origin $(COMMIT) && git reset --hard FETCH_HEAD
endef
GIT_CLONE = ${if $(COMMIT), $(GIT_CLONE_COMMIT), git clone --recursive --depth=1 -c advice.detachedHead=false -b $(TAG) $(REPO) $(WORKDIR)}

.PHONY: all get

all: $(WORKDIR)
	cp -r dune-files/* $(WORKDIR)/
	dune build -p $(SUBPKGS_BUILD)

get: $(WORKDIR)

$(WORKDIR):
	$(GIT_CLONE)
	( cd $(WORKDIR) && git apply ../mathcomp-fast-load.patch )

install:
	dune install $(SUBPKGS)
