ifeq ($(OS),Windows_NT)
    SHELL := pwsh.exe
else
   SHELL := pwsh
endif
.SHELLFLAGS := -NoProfile -Command 

REGISTRY_NAME := 
REPOSITORY_NAME := bmcclure89/
IMAGE_NAME := math_worksheet_generator
TAG := :latest

.PHONY:= all clean test run
all: build

getcommitid: 
	$(eval COMMITID = $(shell git log -1 --pretty=format:"%H"))

getbranchname:
	$(eval BRANCH_NAME = $(shell (git branch --show-current ) -replace '/','.'))

build: getcommitid getbranchname
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME).$(COMMITID) .

run: 
	docker run -v $${PWD}:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --output /out/worksheet.pdf

hugo_build: 
	docker run --rm -it -v $${PWD}/docs:/src klakegg/hugo:0.92.1
hugo_preview:
	docker run --rm -it -v $${PWD}/docs:/src -p 8000:8000 klakegg/hugo:0.92.1 server --port 8000 --disableFastRender
run: run_examples
run_examples:
	docker run -v $${PWD}/examples:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --pageStyle small --output /out/small.pdf
	docker run -v $${PWD}/examples:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --pageStyle medium --output /out/medium.pdf
	docker run -v $${PWD}/examples:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --pageStyle large --output /out/large.pdf

lint_mega:
	docker run -v $${PWD}:/tmp/lint oxsecurity/megalinter:v6
lint_goodcheck:
	docker run -t --rm -v $${PWD}:/work sider/goodcheck check
lint_goodcheck_test:
	docker run -t --rm -v $${PWD}:/work sider/goodcheck test
lint_makefile:
	docker run -v $${PWD}:/tmp/lint -e ENABLE_LINTERS=MAKEFILE_CHECKMAKE oxsecurity/megalinter-ci_light:v6.10.0

clean:
	'Not implemented'
test:
	'Not Implemented'