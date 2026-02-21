###########
# Helpers #
###########
# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
SED = sed -i
endif
ifeq ($(UNAME), Darwin)
SED = sed -i '' -e
endif


.PHONY: gen-python gen-cpp gen-js gen-jupyter gen-rust gen-rustjswasm
gen-python:  ## regenerate the python template from scratch
	mkdir -p ../python-template && cd ../python-template && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template --data-file examples/python.yaml
	cd ../python-template && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

gen-cpp:  ## regenerate the c++ template from scratch
	mkdir -p ../python-template-cpp && cd ../python-template-cpp && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template-cpp --data-file examples/cpp.yaml
	cd ../python-template-cpp && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

gen-js:  ## regenerate the js template from scratch
	mkdir -p ../python-template-js && cd ../python-template-js && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template-js --data-file examples/js.yaml
	cd ../python-template-js && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

gen-jupyter:  ## regenerate the jupyter template from scratch
	mkdir -p ../python-template-jupyter && cd ../python-template-jupyter && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template-jupyter --data-file examples/jupyter.yaml
	cd ../python-template-jupyter && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

gen-rust:  ## regenerate the rust template from scratch
	mkdir -p ../python-template-rust && cd ../python-template-rust && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template-rust --data-file examples/rust.yaml
	cd ../python-template-rust && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

gen-rustjswasm:  ## regenerate the rustjswasm template from scratch
	mkdir -p ../python-template-rustjswasm && cd ../python-template-rustjswasm && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template-rustjswasm --data-file examples/rustjswasm.yaml
	cd ../python-template-rustjswasm && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

gen-cppjswasm:  ## regenerate the cppjswasm template from scratch
	mkdir -p ../python-template-cppjswasm && cd ../python-template-cppjswasm && rm -rf ./* && rm -rf .copier-answers.yaml .gitignore .github .gitattributes
	copier copy -w . ../python-template-cppjswasm --data-file examples/cppjswasm.yaml
	cd ../python-template-cppjswasm && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yaml

.PHONY: test-python test-cpp test-js test-jupyter test-rust test-rustjswasm
test-python:
	cd ../python-template && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template && make develop
	cd ../python-template && make lint
	cd ../python-template && make checks
	cd ../python-template && make test

test-cpp:
	cd ../python-template-cpp && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-cpp && make develop
	cd ../python-template-cpp && make lint
	cd ../python-template-cpp && make checks
	cd ../python-template-cpp && make test

test-js:
	cd ../python-template-js && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-js && make develop
	cd ../python-template-js && git add js/pnpm-lock.yaml && git commit -m "lockfile"
	cd ../python-template-js && make lint
	cd ../python-template-js && make checks
	cd ../python-template-js && make test

test-jupyter:
	cd ../python-template-jupyter && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-jupyter && make develop
	cd ../python-template-jupyter && git add js/pnpm-lock.yaml && git commit -m "lockfile"
	cd ../python-template-jupyter && make lint
	cd ../python-template-jupyter && make checks
	cd ../python-template-jupyter && make test

test-rust:
	cd ../python-template-rust && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-rust && make develop
	cd ../python-template-rust && git add Cargo.lock && git commit -m "lockfile"
	cd ../python-template-rust && make lint
	cd ../python-template-rust && make checks
	cd ../python-template-rust && make test

test-rustjswasm:
	cd ../python-template-rustjswasm && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-rustjswasm && make develop
	cd ../python-template-rustjswasm && git add Cargo.lock && git commit -m "lockfile"
	cd ../python-template-jupyter && git add js/pnpm-lock.yaml && git commit -m "lockfile"
	cd ../python-template-rustjswasm && make lint
	cd ../python-template-rustjswasm && make checks
	cd ../python-template-rustjswasm && make test

test-cppjswasm:
	cd ../python-template-cppjswasm && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-cppjswasm && make develop
	cd ../python-template-jupyter && git add js/pnpm-lock.yaml && git commit -m "lockfile"
	cd ../python-template-cppjswasm && make lint
	cd ../python-template-cppjswasm && make checks
	cd ../python-template-cppjswasm && make test
