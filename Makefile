###########
# Helpers #
###########
# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: gen-python
gen-python:  ## regenerate the python template from scratch
	mkdir -p ../python-template && cd ../python-template && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../python-template --data-file examples/python.yml

.PHONY: gen-cpp
gen-cpp:  ## regenerate the c++ template from scratch
	mkdir -p ../cpp-template && cd ../cpp-template && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../cpp-template --data-file examples/cpp.yml

.PHONY: gen-js
gen-js:  ## regenerate the js template from scratch
	mkdir -p ../js-template && cd ../js-template && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../js-template --data-file examples/js.yml

.PHONY: gen-jupyter
gen-jupyter:  ## regenerate the jupyter template from scratch
	mkdir -p ../jupyter-template && cd ../jupyter-template && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../jupyter-template --data-file examples/jupyter.yml

.PHONY: gen-rust
gen-rust:  ## regenerate the rust template from scratch
	mkdir -p ../rust-template && cd ../rust-template && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../rust-template --data-file examples/rust.yml

