# # # # # Begin docker related section # # # # #

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

run: image
	docker run --rm -it -v $(shell pwd):/host -u $(USER) $(IMAGE_NAME)

# # # # # End docker related section # # # # #