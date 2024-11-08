# Makefile

# Load environment variables from .env file
ifneq ("$(wildcard .env)","")
    include .env
    export
endif

.PHONY: sim all

all: compile

sim:
	cd sim/script && ./simulate.bat

compile:
	cd hw && ./compile.bat

program:
	cd hw && ./program.bat

wipe:
	cd hw && rm -rf project output_files 
	rm -rf software/*