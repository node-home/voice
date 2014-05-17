CWD := $(shell pwd)
BIN = ./node_modules/.bin
SRC = $(wildcard src/*.coffee)
LIB = ./lib
COFFEE = @$(BIN)/coffee \
		--output lib/ \
		src/
MOCHA = @$(BIN)/mocha \
	--require should \
	--compilers coffee:coffee-script/register \
	test/**/*.coffee
UGLIFY = @$(BIN)/uglifyjs \
	--output

watch:
	$(COFFEE) --watch

build:
	$(COFFEE)

test: build
	$(MOCHA) \
		--bail \
		--reporter progress

test-all: build
	$(MOCHA) \
		--reporter spec

test-watch: watch
	$(MOCHA) \
		--bail \
		--watch \
		--reporter min

clean:
	@rm -f $(LIB)

install link:
	@npm $@

define release
	VERSION=`node -pe "require('./package.json').version"` && \
	NEXT_VERSION=`node -pe "require('semver').inc(\"$$VERSION\", '$(1)')"` && \
	node -e "\
		var j = require('./package.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./package.json', s);" && \
	git commit -m "release $$NEXT_VERSION" -- package.json && \
	git tag "$$NEXT_VERSION" -m "release $$NEXT_VERSION"
endef

release-patch: build test
	@$(call release,patch)

release-minor: build test
	@$(call release,minor)

release-major: build test
	@$(call release,major)

publish:
	git push --tags origin HEAD:master
	npm publish

.PHONY: test
