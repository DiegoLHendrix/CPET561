# Makefile

# Load environment variables from .env file
ifneq ("$(wildcard .env)","")
    include .env
    export
endif

.PHONY: sim all

all: run

sim:
	cd sim/script && ./simulate.bat

compile:
	cd hw && ./compile.bat

program:
	cd hw && ./program.bat

env:
	rm -rf __pycache__
	rm -rf venv
	@echo "Creating a new virtual environment..."
	python -m venv venv
	venv/Scripts/python.exe -m pip install --upgrade pip
	pip install -r requirements.txt

wipe:
	python -m pip freeze > all_packages.txt
	python -m pip uninstall -r all_packages.txt -y
	rm all_packages.txt
	rm -rf __pycache__
	rm -rf venv