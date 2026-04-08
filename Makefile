LOGIN		= dopereir
DATA_PATH	= /home/$(LOGIN)/data
COMPOSE		= docker compose -f srcs/docker-compose.yml
COMPOSE_BONUS	= docker compose -f srcs/docker-compose.yml -f srcs/docker-compose.bonus.yml

# Colors
GREEN		= \033[0;32m
YELLOW		= \033[0;33m
RED			= \033[0;31m
RESET		= \033[0m

all: setup up

setup:
	@echo "$(YELLOW)Creating data directories...$(RESET)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "$(GREEN)Directories created at $(DATA_PATH)$(RESET)"

up: setup
	@echo "$(YELLOW)Building and starting containers...$(RESET)"
	@$(COMPOSE) up -d --build
	@echo "$(GREEN)All containers are up!$(RESET)"

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)Containers stopped.$(RESET)"

stop:
	@echo "$(YELLOW)Pausing containers...$(RESET)"
	@$(COMPOSE) stop

start:
	@echo "$(YELLOW)Starting containers...$(RESET)"
	@$(COMPOSE) start

build:
	@echo "$(YELLOW)Rebuilding images...$(RESET)"
	@$(COMPOSE) build --no-cache

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f

## Show logs for a specific service: make log s=nginx
log:
	@$(COMPOSE) logs -f $(s)

fclean:
	@echo "$(YELLOW)Stopping all containers (including bonus)...$(RESET)"
	@$(COMPOSE_BONUS) down --remove-orphans
	@echo "$(RED)Removing all containers, images and volumes...$(RESET)"
	@docker system prune -af
	@docker volume prune -f
	@echo "$(RED)Removing data directories...$(RESET)"
	@sudo rm -rf $(DATA_PATH)
	@echo "$(GREEN)Full clean complete.$(RESET)"

re: fclean all

bonus: setup bonus_up

bonus_up:
	@echo "$(YELLOW)Building and starting containers with Redis bonus...$(RESET)"
	@$(COMPOSE_BONUS) up -d --build
	@echo "$(GREEN)All containers with Redis are up!$(RESET)"

bonus_down:
	@echo "$(YELLOW)Stopping Redis bonus containers...$(RESET)"
	@$(COMPOSE_BONUS) down
	@echo "$(GREEN)Containers stopped.$(RESET)"

.PHONY: all setup up down stop start build ps logs log fclean re bonus bonus_up bonus_down
