MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TESTCASE_DIR  = $(MAKEFILE_DIR)

SIM ?= $(VERIFICATION_SIMULATOR)
TOPLEVEL_LANG ?= verilog

TOPLEVEL = $(VERIFICATION_DUT)
VERILOG_SOURCES = $(VERIFICATION_DESIGN_FILES)

export PYTHONPATH := $(MAKEFILE_DIR):$(PYTHONPATH)
MODULE = base_test

include $(shell cocotb-config --makefiles)/Makefile.sim
