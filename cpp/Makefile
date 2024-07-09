.DEFAULT_GOAL := help
.PHONY: help
# Thanks to Francoise at marmelab.com for this
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

OTHER_ARGS :=

.PHONY: develop-py develop-rust develop
develop-py:
	pip install -U toml
	pip install `python -c 'import toml; c = toml.load("pyproject.toml"); print(" ".join(c["project"]["optional-dependencies"]["develop"]))'`

develop-cpp:
	echo "C++ ready"

develop: develop-py  ## Setup project for development

.PHONY: build-py build-cpp build
build-py:
	python setup.py build build_ext --inplace

build-cpp:
	cmake -B build . -DBUILD_PYTHON=Off
	cmake --build build -- -j8

build: build-cpp build-py  ## Build the project

.PHONY: lint-py lint-cpp lint
lint-py:
	python -m ruff cpp_template

lint-cpp:
	clang-format --dry-run -Werror -i -style=file `find ./src -name "*.*pp"`

lint: lint-cpp lint-py  ## Run project linters

.PHONY: fix-py fix-cpp fix
fix-py:
	python -m ruff cpp_template --fix

fix-cpp:
	clang-format -i -style=file `find ./src -name "*.*pp"`

fix: fix-cpp fix-py  ## Run project autofixers

.PHONY: tests-py tests-cpp tests test tests-ci
tests-py:
	python -m pytest -v cpp_template/tests --junitxml=junit.xml --cov=cpp_template --cov-branch --cov-fail-under=65 --cov-report term-missing --cov-report xml

tests-cpp:
	echo "TODO C++ tests"

tests: tests-cpp tests-py  ## Run the tests
test: tests

tests-ci: tests-cpp tests-py

.PHONY: dist-sdist dist-wheel dist publish

dist-sdist:  ## Create python source dist
	python setup.py sdist

dist-wheel:  ## Create python wheel dist
	python setup.py bdist_wheel $(OTHER_ARGS)

dist-cibw:  ## Create python wheel dist with cibuildwheel
	python -m cibuildwheel --output-dir dist 

dist: build dist-sdist dist-wheel  ## Create python dists
	python -m twine check target/wheels/*

publish: dist  ## Dist assets to pypi
	python -m twine upload target/wheels/* --skip-existing

clean:  ## Clean the repo
	git clean -fdx
