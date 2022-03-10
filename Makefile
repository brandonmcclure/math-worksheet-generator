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
run_examples:
	docker run -v $${PWD}/examples:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --pageStyle small --output /out/small.pdf
	docker run -v $${PWD}/examples:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --pageStyle medium --output /out/medium.pdf
	docker run -v $${PWD}/examples:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type + --digits 1 -q 10 --pageStyle large --output /out/large.pdf
