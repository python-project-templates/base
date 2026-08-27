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


.PHONY: lint fix format test
lint:  ## lint this repo
fix:  ## fix formatting in this repo
format: fix
test:  ## run tests for this repo

.PHONY: gen-python gen-cpp gen-js gen-jupyter gen-rust gen-rustjswasm gen-cppjswasm gen-uitk-svelte gen-uitk-webawesome gen-site-react gen-site-sveltekit gen-site-webawesome
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

gen-uitk-svelte:  ## regenerate the Svelte UI toolkit template from scratch
	mkdir -p ../javascript-template-uitk-svelte && cd ../javascript-template-uitk-svelte && rm -rf ./* && rm -rf .copier-answers.yaml .github .gitignore .prettierignore .prettierrc .oxfmtrc.json .oxlintrc.json
	copier copy -w . ../javascript-template-uitk-svelte --data-file examples/uitk-svelte.yaml

gen-uitk-webawesome:  ## regenerate the Lit and Web Awesome UI toolkit template from scratch
	mkdir -p ../javascript-template-uitk-webawesome && cd ../javascript-template-uitk-webawesome && rm -rf ./* && rm -rf .copier-answers.yaml .github .gitignore .prettierignore .prettierrc .oxfmtrc.json .oxlintrc.json
	copier copy -w . ../javascript-template-uitk-webawesome --data-file examples/uitk-webawesome.yaml

gen-site-react:  ## regenerate the React site template from scratch
	mkdir -p ../javascript-template-site-react && cd ../javascript-template-site-react && rm -rf ./* && rm -rf .copier-answers.yaml .github .gitignore .oxfmtrc.json .oxlintrc.json
	copier copy -w . ../javascript-template-site-react --data-file examples/site-react.yaml

gen-site-sveltekit:  ## regenerate the SvelteKit site template from scratch
	mkdir -p ../javascript-template-site-sveltekit && cd ../javascript-template-site-sveltekit && rm -rf ./* && rm -rf .copier-answers.yaml .github .gitignore .prettierignore .prettierrc .oxfmtrc.json .oxlintrc.json
	copier copy -w . ../javascript-template-site-sveltekit --data-file examples/site-sveltekit.yaml

gen-site-webawesome:  ## regenerate the Web Awesome site template from scratch
	mkdir -p ../javascript-template-site-webawesome && cd ../javascript-template-site-webawesome && rm -rf ./* && rm -rf .copier-answers.yaml .github .gitignore .prettierignore .prettierrc .oxfmtrc.json .oxlintrc.json
	copier copy -w . ../javascript-template-site-webawesome --data-file examples/site-webawesome.yaml

.PHONY: test-python test-cpp test-js test-jupyter test-rust test-rustjswasm test-cppjswasm test-uitk-svelte test-uitk-webawesome test-site-react test-site-sveltekit test-site-webawesome
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
	cd ../python-template-rustjswasm && git add js/pnpm-lock.yaml && git commit -m "lockfile"
	cd ../python-template-rustjswasm && make lint
	cd ../python-template-rustjswasm && make checks
	cd ../python-template-rustjswasm && make test

test-cppjswasm:
	cd ../python-template-cppjswasm && git config --global user.name "github-actions" && git config --global user.email "41898282+github-actions[bot]@users.noreply.github.c@example.com" && git init && git add . && git commit -m "initial commit"
	cd ../python-template-cppjswasm && make develop
	cd ../python-template-cppjswasm && git add js/pnpm-lock.yaml && git commit -m "lockfile"
	cd ../python-template-cppjswasm && make lint
	cd ../python-template-cppjswasm && make checks
	cd ../python-template-cppjswasm && make test

test-uitk-svelte:
	cd ../javascript-template-uitk-svelte && pnpm install
	cd ../javascript-template-uitk-svelte && pnpm exec playwright install chromium
	cd ../javascript-template-uitk-svelte && pnpm lint
	cd ../javascript-template-uitk-svelte && pnpm check
	cd ../javascript-template-uitk-svelte && pnpm build
	cd ../javascript-template-uitk-svelte && pnpm test:unit
	cd ../javascript-template-uitk-svelte && CI=1 pnpm test:e2e

test-uitk-webawesome:
	cd ../javascript-template-uitk-webawesome && pnpm install
	cd ../javascript-template-uitk-webawesome && pnpm exec playwright install chromium
	cd ../javascript-template-uitk-webawesome && pnpm lint
	cd ../javascript-template-uitk-webawesome && pnpm check
	cd ../javascript-template-uitk-webawesome && pnpm build
	cd ../javascript-template-uitk-webawesome && pnpm test:unit
	cd ../javascript-template-uitk-webawesome && CI=1 pnpm test:e2e

test-site-react:
	cd ../javascript-template-site-react && pnpm install
	cd ../javascript-template-site-react && pnpm exec playwright install chromium
	cd ../javascript-template-site-react && pnpm lint
	cd ../javascript-template-site-react && pnpm check
	cd ../javascript-template-site-react && pnpm build
	cd ../javascript-template-site-react && pnpm test:unit
	cd ../javascript-template-site-react && CI=1 pnpm test:e2e

test-site-sveltekit:
	cd ../javascript-template-site-sveltekit && pnpm install
	cd ../javascript-template-site-sveltekit && pnpm exec playwright install chromium
	cd ../javascript-template-site-sveltekit && pnpm lint
	cd ../javascript-template-site-sveltekit && pnpm check
	cd ../javascript-template-site-sveltekit && pnpm build
	cd ../javascript-template-site-sveltekit && CI=1 pnpm test:e2e

test-site-webawesome:
	cd ../javascript-template-site-webawesome && pnpm install
	cd ../javascript-template-site-webawesome && pnpm exec playwright install chromium
	cd ../javascript-template-site-webawesome && pnpm lint
	cd ../javascript-template-site-webawesome && pnpm check
	cd ../javascript-template-site-webawesome && pnpm build
	cd ../javascript-template-site-webawesome && CI=1 pnpm test:e2e
