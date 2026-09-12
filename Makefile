NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/nakbas/data

all: prepare up

prepare:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb

build: prepare
	@docker compose -f $(COMPOSE_FILE) build

up: prepare
	@docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@docker compose -f $(COMPOSE_FILE) down

start:
	@docker compose -f $(COMPOSE_FILE) start

stop:
	@docker compose -f $(COMPOSE_FILE) stop

clean: down
	@docker compose -f $(COMPOSE_FILE) down -v --remove-orphans

fclean: clean
	@echo "Tüm container, imaj ve veri hacimleri temizleniyor..."
	@docker system prune -a --volumes -f
	@sudo rm -rf $(DATA_DIR)

re: fclean all

.PHONY: all prepare build up down start stop clean fclean re
