# # # # # Begin docker image creation related section # # # # #

IMAGE_NAME := overlydev/hugo
CONTEXT_DIR := docker/_context
USER := $(shell id -u):$(shell id -g)

docker_context:
	rm -rf $(CONTEXT_DIR)
	mkdir $(CONTEXT_DIR)
	cp docker/Dockerfile $(CONTEXT_DIR)/.
	cp docker/*.txt $(CONTEXT_DIR)/.

image: docker_context
	cd $(CONTEXT_DIR) && docker build -t $(IMAGE_NAME) .

# # # # # End docker image creation related section # # # # #

# # # # # Begin hugo specific section # # # # #

hugo_exec:
	docker run --rm -it -v $(shell pwd):/host -u $(USER) -w /host/site $(IMAGE_NAME)

hugo_clean:
	cd site && rm -rf public resources .hugo_build.lock

hugo_serve: hugo_clean
	docker run --name hugo_serve --rm -it -v $(shell pwd):/host -u $(USER) -w /host/site -p 1313:1313 $(IMAGE_NAME) hugo server -DEF --bind 0.0.0.0

hugo_prod: hugo_clean
	docker run --name hugo_serve --rm -it -v $(shell pwd):/host -u $(USER) -w /host/site -p 1313:1313 $(IMAGE_NAME) hugo server --environment production --bind 0.0.0.0

hugo_build:
	docker run --rm -d -v $(shell pwd):/host -u $(USER) -w /host/site $(IMAGE_NAME) hugo --gc --minify

# # # # # End hugo specific section # # # # #