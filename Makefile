LOGIN		= dopereir
DATA_PATH	= /home/$(LOGIN)/data
COMPOSE		= docker compose -f srcs/docker-compose.yml

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
	@mkdir -p $(DATA_PATH)/redis
	@echo "$(GREEN)Directories created at $(DATA_PATH)$(RESET)"

up: setup
	@echo "$(YELLOW)Building and starting containers...$(RESET)"
	@$(COMPOSE) up -d --build
	@echo "$(GREEN)All containers are up!$(RESET)"

bonus: setup
	@echo "$(YELLOW)Building and starting mandatory + bonus containers...$(RESET)"
	@$(COMPOSE) --profile bonus up -d --build
	@echo "$(GREEN)Bonus stack is up!$(RESET)"

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

log:
	@$(COMPOSE) logs -f $(s)

## make rebuild s=wordpress
rebuild:
	@echo "$(YELLOW)Rebuilding $(s)...$(RESET)"
	@$(COMPOSE) up -d --build --no-deps $(s)
	@echo "$(GREEN)$(s) rebuilt and restarted!$(RESET)"

fclean: down
	@echo "$(RED)Removing all containers, images and volumes...$(RESET)"
	@docker system prune -af
	@docker volume prune -f
	@echo "$(RED)Removing data directories...$(RESET)"
	@sudo rm -rf $(DATA_PATH)
	@echo "$(GREEN)Full clean complete.$(RESET)"

re: fclean all

.PHONY: all setup up bonus down stop start build ps logs log rebuild fclean re
