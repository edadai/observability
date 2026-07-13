.PHONY: up down restart pull logs ps validate backup

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

pull:
	docker compose pull

logs:
	docker compose logs -f --tail=200

ps:
	docker compose ps

validate:
	docker compose config >/dev/null
	docker run --rm \
		-v "$(PWD)/alloy/config.alloy:/etc/alloy/config.alloy:ro" \
		grafana/alloy:v1.17.1 \
		validate /etc/alloy/config.alloy

backup:
	mkdir -p backups
	docker run --rm \
		-v edadai-grafana-data:/source:ro \
		-v "$(PWD)/backups:/backup" \
		alpine \
		tar czf /backup/grafana-$$(date +%Y%m%d-%H%M%S).tar.gz -C /source .

	docker run --rm \
		-v edadai-loki-data:/source:ro \
		-v "$(PWD)/backups:/backup" \
		alpine \
		tar czf /backup/loki-$$(date +%Y%m%d-%H%M%S).tar.gz -C /source .
