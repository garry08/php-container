BUILD_NAME=php
COMPOSE_BUILD_NAME=php-container
VERSIONS=7.2 7.1
ALL=$(addprefix php,$(VERSIONS))
VCS_REF="$(shell git rev-parse HEAD)"
BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%m:%SZ")"

.PHONY: all
all: $(ALL)

.PHONY: $(ALL)
$(ALL):
	VCS_REF=$(VCS_REF) \
	BUILD_DATE=$(BUILD_DATE) \
	COMPOSE_BUILD_NAME=$(COMPOSE_BUILD_NAME) \
	docker-compose -f build.yml build \
		$@

.PHONY:clean
clean:
	for VERSION in $(VERSIONS); do \
		docker image rm -f $(COMPOSE_BUILD_NAME):$$VERSION; \
	done
