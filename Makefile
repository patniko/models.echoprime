# Makefile for EchoPrime project
# Provides easy commands for downloading model data, setting up environment, and running Jupyter

# Variables
PYTHON := python3
POETRY := poetry
JUPYTER_PORT := 8888
MODEL_DATA_URL := https://github.com/echonet/EchoPrime/releases/download/v1.0.0/model_data.zip
EMBEDDING_P1_URL := https://github.com/echonet/EchoPrime/releases/download/v1.0.0/candidate_embeddings_p1.pt
EMBEDDING_P2_URL := https://github.com/echonet/EchoPrime/releases/download/v1.0.0/candidate_embeddings_p2.pt

# Colors for terminal output
YELLOW := \033[1;33m
GREEN := \033[1;32m
NC := \033[0m # No Color

# Help command
.PHONY: help
help:
	@echo "${YELLOW}EchoPrime Makefile Commands:${NC}"
	@echo ""
	@echo "${GREEN}Setup Commands:${NC}"
	@echo "  make setup              Setup Poetry environment"
	@echo "  make setup-legacy       Setup environment using requirements.txt"
	@echo "  make download-data      Download model data and embeddings"
	@echo "  make all                Setup environment and download data"
	@echo "  make setup-and-run      Setup, download data, and run Jupyter"
	@echo ""
	@echo "${GREEN}Run Commands:${NC}"
	@echo "  make jupyter            Run Jupyter notebook"
	@echo ""
	@echo "${GREEN}Docker Commands:${NC}"
	@echo "  make build-docker       Build the Docker image"
	@echo "  make run-docker         Run Docker container"
	@echo ""
	@echo "${GREEN}Utility Commands:${NC}"
	@echo "  make clean              Clean up temporary files"
	@echo ""
	@echo "Example usage:"
	@echo "  make jupyter JUPYTER_PORT=8889"

# Setup commands
.PHONY: setup
setup:
	@echo "${YELLOW}Setting up Poetry environment...${NC}"
	@$(POETRY) install
	@echo "${GREEN}Poetry environment setup complete!${NC}"

.PHONY: setup-legacy
setup-legacy:
	@echo "${YELLOW}Setting up environment using requirements.txt...${NC}"
	@$(PYTHON) -m pip install -r requirements.txt
	@echo "${GREEN}Environment setup complete!${NC}"

.PHONY: download-data
download-data:
	@echo "${YELLOW}Downloading model data and embeddings...${NC}"
	@if [ ! -d "model_data" ] || [ ! -f "model_data/weights/echo_prime_encoder.pt" ]; then \
		echo "Downloading model_data.zip..."; \
		wget -q --show-progress $(MODEL_DATA_URL); \
		echo "Extracting model_data.zip..."; \
		unzip -q model_data.zip; \
		rm model_data.zip; \
	else \
		echo "model_data directory already exists with weights."; \
	fi
	
	@if [ ! -f "model_data/candidates_data/candidate_embeddings_p1.pt" ]; then \
		echo "Downloading candidate_embeddings_p1.pt..."; \
		wget -q --show-progress $(EMBEDDING_P1_URL); \
		echo "Moving candidate_embeddings_p1.pt to model_data/candidates_data/"; \
		mv candidate_embeddings_p1.pt model_data/candidates_data/; \
	else \
		echo "candidate_embeddings_p1.pt already exists."; \
	fi
	
	@if [ ! -f "model_data/candidates_data/candidate_embeddings_p2.pt" ]; then \
		echo "Downloading candidate_embeddings_p2.pt..."; \
		wget -q --show-progress $(EMBEDDING_P2_URL); \
		echo "Moving candidate_embeddings_p2.pt to model_data/candidates_data/"; \
		mv candidate_embeddings_p2.pt model_data/candidates_data/; \
	else \
		echo "candidate_embeddings_p2.pt already exists."; \
	fi
	
	@echo "${GREEN}Model data and embeddings download complete!${NC}"

# Run commands
.PHONY: jupyter
jupyter:
	@echo "${YELLOW}Starting Jupyter notebook on port $(JUPYTER_PORT)${NC}"
	@$(POETRY) run jupyter notebook --port $(JUPYTER_PORT)

# Docker commands
.PHONY: build-docker
build-docker:
	@echo "${YELLOW}Building Docker image...${NC}"
	@docker build -t echo-prime .
	@echo "${GREEN}Docker image built successfully!${NC}"

.PHONY: run-docker
run-docker:
	@echo "${YELLOW}Running Docker container...${NC}"
	@docker run -d --name echoprime-container --gpus all -p $(JUPYTER_PORT):8888 echo-prime
	@echo "${GREEN}Docker container started!${NC}"
	@echo "You can access Jupyter notebook at http://localhost:$(JUPYTER_PORT)"
	@echo "To attach to the container: docker exec -it echoprime-container /bin/bash"

# Utility commands
.PHONY: clean
clean:
	@echo "${YELLOW}Cleaning up temporary files...${NC}"
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete
	@find . -type f -name "*.pyo" -delete
	@find . -type f -name "*.pyd" -delete
	@find . -type f -name ".DS_Store" -delete
	@find . -type d -name "*.egg-info" -exec rm -rf {} +
	@find . -type d -name "*.egg" -exec rm -rf {} +
	@find . -type d -name ".pytest_cache" -exec rm -rf {} +
	@find . -type d -name ".coverage" -exec rm -rf {} +
	@find . -type d -name "htmlcov" -exec rm -rf {} +
	@find . -type d -name ".ipynb_checkpoints" -exec rm -rf {} +
	@echo "${GREEN}Cleanup complete!${NC}"

# All-in-one setup command
.PHONY: all
all: setup download-data

# All-in-one setup and run command
.PHONY: setup-and-run
setup-and-run: all jupyter

# Default target
.DEFAULT_GOAL := help
