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


.PHONY: gen-python
gen-python:  ## regenerate the python template from scratch
	mkdir -p ../python-template && cd ../python-template && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../python-template --data-file examples/python.yml
	cd ../python-template && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yml

.PHONY: gen-cpp
gen-cpp:  ## regenerate the c++ template from scratch
	mkdir -p ../python-template-cpp && cd ../python-template-cpp && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../python-template-cpp --data-file examples/cpp.yml
	cd ../python-template-cpp && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yml

.PHONY: gen-js
gen-js:  ## regenerate the js template from scratch
	mkdir -p ../python-template-js && cd ../python-template-js && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../python-template-js --data-file examples/js.yml
	cd ../python-template-js && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yml

.PHONY: gen-jupyter
gen-jupyter:  ## regenerate the jupyter template from scratch
	mkdir -p ../python-template-jupyter && cd ../python-template-jupyter && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../python-template-jupyter --data-file examples/jupyter.yml
	cd ../python-template-jupyter && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yml

.PHONY: gen-rust
gen-rust:  ## regenerate the rust template from scratch
	mkdir -p ../python-template-rust && cd ../python-template-rust && rm -rf ./* && rm -rf .copier-answers.yml .gitignore .github .gitattributes
	copier copy -w . ../python-template-rust --data-file examples/rust.yml
	cd ../python-template-rust && $(SED) 's#_src_path: .#_src_path: https://github.com/python-project-templates/base.git#g' ./.copier-answers.yml

