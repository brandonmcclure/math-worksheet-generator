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

all: docker_build

getcommitid: 
	$(eval COMMITID = $(shell git log -1 --pretty=format:"%H"))

getbranchname:
	$(eval BRANCH_NAME = $(shell (git branch --show-current ) -replace '/','.'))

docker_build: getcommitid getbranchname
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME).$(COMMITID) .

run: 
	docker run -v $${PWD}:/out $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):latest --type +-x --digits 1 -q 10 --output /out/worksheet.pdf