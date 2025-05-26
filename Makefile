.PHONY: start
start: stop
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose down --remove-orphans