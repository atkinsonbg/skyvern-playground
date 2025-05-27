.PHONY: start
start: stop
	mkdir -p .artifacts .videos .har .log .streamlit
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose down --remove-orphans