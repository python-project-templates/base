
EMSDK_VERSION ?= latest
EMSDK_DIR := $(shell cd .. && pwd)/emsdk

.PHONY: requirements develop build
requirements:  ## install emsdk locally and ensure C++ toolchain is available
	@if [ ! -d "$(EMSDK_DIR)" ]; then \
		echo "Installing emsdk locally into $(EMSDK_DIR)..." && \
		git clone https://github.com/emscripten-core/emsdk.git "$(EMSDK_DIR)" && \
		cd "$(EMSDK_DIR)" && ./emsdk install $(EMSDK_VERSION) && ./emsdk activate $(EMSDK_VERSION); \
	else \
		echo "emsdk already installed at $(EMSDK_DIR)"; \
	fi
	@echo "Ensure C++ compiler (g++/clang++) and clang-format are available"

develop: requirements  ## install required dev dependencies

build:  ## verify standalone C++ compilation
	@echo "C++ library is compiled as part of Python (hatch-cpp) and JavaScript (emscripten) builds"

.PHONY: lint lints fix format
lint:  ## run clang-format for linting
	clang-format --dry-run -Werror -i -style=file:../.clang-format `find . -name "*.*pp"`
# alias
lints: lint

fix:  ## fix code with clang-format
	clang-format -i -style=file:../.clang-format `find . -name "*.*pp"`
#alias
format: fix

.PHONY: check checks
check:  ## verify compilation
	@echo "C++ library is checked as part of Python and JavaScript builds"
# alias
checks: check

.PHONY: test tests coverage
test:  ## run the tests
	@echo "C++ tests are run through Python and JavaScript test suites"

# alias
tests: test

coverage: test

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'
