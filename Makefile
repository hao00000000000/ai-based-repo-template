# Makefile
#
# Generic project commands template.
# Replace the command bodies with your actual stack commands.
#
# Usage:
#   make help          — list all available commands
#   make install       — install dependencies
#   make build         — build the project
#   make run           — start the development server
#   make lint          — run linter
#   make format        — auto-format code
#   make type-check    — run type checker
#   make test          — run test suite
#   make check         — run all quality gates (lint + format-check + type-check + test)
#   make task-new      — create a new task spec from template
#   make log-compress  — compress old docs/logs when count > 10
#   make docs-check    — verify docs are consistent with each other

.PHONY: help install build run lint format format-check type-check test check task-new log-compress docs-check

# ─── Configuration ────────────────────────────────────────────────────────────

# Override these variables per project, e.g.:
#   make run PORT=8080
#   make test TEST_PATH=tests/unit
APP_DIR     ?= app
TEST_DIR    ?= tests
PORT        ?= 8000
LOG_DIR     ?= docs/logs
TASK_DIR    ?= ai/tasks

# ─── Help ─────────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "  Available commands:"
	@echo ""
	@echo "  Development"
	@echo "    make install        Install dependencies"
	@echo "    make build          Build the project"
	@echo "    make run            Start development server (PORT=$(PORT))"
	@echo ""
	@echo "  Quality Gates"
	@echo "    make lint           Run linter"
	@echo "    make format         Auto-format code"
	@echo "    make format-check   Check formatting without modifying files"
	@echo "    make type-check     Run type checker"
	@echo "    make test           Run test suite"
	@echo "    make check          Run all quality gates (lint + format-check + type-check + test)"
	@echo ""
	@echo "  AI Workflow"
	@echo "    make task-new       Create a new task spec (TYPE=feature NAME=my-task)"
	@echo "    make log-compress   Compress docs/logs when count > 10"
	@echo "    make docs-check     Check doc consistency"
	@echo ""

# ─── Development ──────────────────────────────────────────────────────────────

install:
	# TODO: replace with your package manager command
	# Examples:
	#   poetry install
	#   npm install
	#   pip install -r requirements.txt
	@echo "install: not configured — edit Makefile"

build:
	# TODO: replace with your build command
	# Examples:
	#   poetry run python -m build
	#   npm run build
	#   go build ./...
	@echo "build: not configured — edit Makefile"

run:
	# TODO: replace with your run command
	# Examples:
	#   poetry run uvicorn app.main:app --reload --port $(PORT)
	#   npm run dev
	#   go run ./cmd/server
	@echo "run: not configured — edit Makefile"

# ─── Quality Gates ────────────────────────────────────────────────────────────

lint:
	# TODO: replace with your linter command
	# Examples:
	#   poetry run ruff check $(APP_DIR) $(TEST_DIR)
	#   npm run lint
	#   golangci-lint run
	@echo "lint: not configured — edit Makefile"

format:
	# TODO: replace with your formatter command
	# Examples:
	#   poetry run ruff format $(APP_DIR) $(TEST_DIR)
	#   npm run format
	@echo "format: not configured — edit Makefile"

format-check:
	# TODO: replace with your format-check command (no file modification)
	# Examples:
	#   poetry run ruff format --check $(APP_DIR) $(TEST_DIR)
	@echo "format-check: not configured — edit Makefile"

type-check:
	# TODO: replace with your type checker command
	# Examples:
	#   poetry run mypy $(APP_DIR)
	#   npm run type-check
	#   go vet ./...
	@echo "type-check: not configured — edit Makefile"

test:
	# TODO: replace with your test runner command
	# Examples:
	#   poetry run pytest -q
	#   npm test
	#   go test ./...
	@echo "test: not configured — edit Makefile"

check: lint format-check type-check test
	@echo "All quality gates passed."

# ─── AI Workflow ──────────────────────────────────────────────────────────────

task-new:
	# Create a new task spec in ai/tasks/active/
	# Usage: make task-new TYPE=feature NAME=my-task
ifndef TYPE
	$(error TYPE is required. Usage: make task-new TYPE=feature NAME=my-task)
endif
ifndef NAME
	$(error NAME is required. Usage: make task-new TYPE=feature NAME=my-task)
endif
	@DATE=$$(date +%Y-%m-%d); \
	DEST="$(TASK_DIR)/active/$${DATE}_$(TYPE)_$(NAME).md"; \
	TEMPLATE="$(TASK_DIR)/examples/$(TYPE)_example.md"; \
	if [ ! -f "$$TEMPLATE" ]; then \
		echo "Template not found: $$TEMPLATE"; \
		exit 1; \
	fi; \
	cp "$$TEMPLATE" "$$DEST"; \
	echo "Created: $$DEST"

log-compress:
	# Compress docs/logs when count exceeds 10
	@COUNT=$$(ls $(LOG_DIR)/*.md 2>/dev/null | grep -v README | wc -l | tr -d ' '); \
	echo "Current log count: $$COUNT"; \
	if [ "$$COUNT" -gt 10 ]; then \
		echo "Count exceeds 10 — compress oldest 10 into archive manually:"; \
		echo "  1. Pick oldest 10 files in $(LOG_DIR)/"; \
		echo "  2. Merge into $(LOG_DIR)/archive/$$(date +%Y-%m-%d)_batch_summary.md"; \
		echo "  3. Delete the 10 individual files"; \
		echo "  4. Update $(LOG_DIR)/README.md index"; \
	else \
		echo "No compression needed."; \
	fi

docs-check:
	# Verify that the four source-of-truth docs exist and are non-empty
	@MISSING=0; \
	for f in docs/PRODUCT.md docs/DOMAIN.md docs/ARCHITECTURE.md docs/TECH.md; do \
		if [ ! -s "$$f" ]; then \
			echo "MISSING or empty: $$f"; \
			MISSING=1; \
		else \
			echo "OK: $$f"; \
		fi; \
	done; \
	if [ "$$MISSING" -eq 1 ]; then \
		echo "docs-check failed: fill in missing source-of-truth docs before proceeding."; \
		exit 1; \
	fi; \
	echo "docs-check passed."
