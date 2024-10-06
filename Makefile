all: .venv

.venv: Makefile
	python3 -m venv .venv
	.venv/bin/python -m pip install weasyprint
