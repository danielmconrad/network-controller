-include .env

N4D   := --project-directory . -f docker/docker-compose.yml
N4T   := --project-directory . -f docker/docker-compose.yml -f docker/docker-compose.test.yml
E2E   := --project-directory . -f docker/docker-compose.yml -f docker/docker-compose.e2e.yml
NOW   := $(shell date "+%Y-%m-%d")

##----------------------------------------------------------------------------------------------------------------------
## Help

.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

%:
	@exit 0

.PHONY:

##----------------------------------------------------------------------------------------------------------------------
##@ Actions

install: install-static-ip install-hostname install-docker
	@make start

install-docker:
	@sudo apt-get install docker
	@sudo groupadd docker
	@sudo usermod -aG docker $${USER}

install-hostname:
	@sudo apt-get install avahi-daemon
	@sudo systemctl enable avahi-daemon.service

install-pihole-reqs:
	@sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
	@sudo sh -c 'rm /etc/resolv.conf && ln -s
	@systemctl restart systemd-resolved

install-static-ip:
	@sudo cp 01-fixed-ip.yaml /etc/netplan/01-fixed-ip.yaml
	@sudo netplan apply

start:
	docker compose up -d
