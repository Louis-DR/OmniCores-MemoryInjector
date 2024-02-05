MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ROOT_DIR = $(MAKEFILE_DIR)
export ROOT_DIR



SOURCES_DIR      = $(ROOT_DIR)/sources/
DEPENDENCIES_DIR = $(ROOT_DIR)/dependencies/
MAKE_DIR         = $(ROOT_DIR)/make/
SCRIPTS_DIR      = $(MAKE_DIR)/scripts/
export SOURCES_DIR
export DEPENDENCIES_DIR
export MAKE_DIR
export SCRIPTS_DIR

DESIGN_SOURCES_DIR       = $(SOURCES_DIR)/design/
HARDWARE_SOURCES_DIR     = $(DESIGN_SOURCES_DIR)/hardware/
RTL_SOURCES_DIR          = $(HARDWARE_SOURCES_DIR)/rtl/
REGISTERS_SOURCES_DIR    = $(HARDWARE_SOURCES_DIR)/registers/
VERIFICATION_SOURCES_DIR = $(SOURCES_DIR)/verification/
export DESIGN_SOURCES_DIR
export HARDWARE_SOURCES_DIR
export RTL_SOURCES_DIR
export REGISTERS_SOURCES_DIR
export VERIFICATION_SOURCES_DIR

DESIGN_GENERATED_DIR       = $(GENERATED_DIR)/design/
HARDWARE_GENERATED_DIR     = $(DESIGN_GENERATED_DIR)/hardware/
RTL_GENERATED_DIR          = $(HARDWARE_GENERATED_DIR)/rtl/
REGISTERS_GENERATED_DIR    = $(HARDWARE_GENERATED_DIR)/registers/
VERIFICATION_GENERATED_DIR = $(GENERATED_DIR)/verification/
export DESIGN_GENERATED_DIR
export HARDWARE_GENERATED_DIR
export RTL_GENERATED_DIR
export REGISTERS_GENERATED_DIR
export VERIFICATION_GENERATED_DIR

GENERATED_DIR    = $(ROOT_DIR)/generated/
BUILD_DIR        = $(ROOT_DIR)/build/
RESULTS_DIR      = $(ROOT_DIR)/results/
export GENERATED_DIR
export BUILD_DIR
export RESULTS_DIR



J2GPP_MAKE_DIR     = $(MAKE_DIR)/j2gpp
J2GPP_SOURCE_FILES = $(shell find $(RTL_GENERATED_DIR))
J2GPP_SOURCE_DIR   = $(SOURCES_DIR)
J2GPP_OUTPUT_DIR   = --outdir $(GENERATED_DIR)
J2GPP_INCLUDE_DIRS = --incdir $(J2GPP_MAKE_DIR)/macros/
J2GPP_FILTERS      = --filters $(wildcard $(J2GPP_MAKE_DIR)/filters/*.py)
J2GPP_VARFILES     = --varfile $(wildcard $(REGISTERS_SOURCES_DIR)/*.yml)
J2GPP_ADAPTERS     = --file-vars-adapter $(J2GPP_MAKE_DIR)/adapters/register_bank_adapter.py register_bank_adapter
J2GPP_FLAGS        = --overwrite-outdir --copy-non-template
J2GPP_ARGUMENTS    = $(J2GPP_SOURCE_DIR) $(J2GPP_OUTPUT_DIR) $(J2GPP_INCLUDE_DIRS) $(J2GPP_FILTERS) $(J2GPP_VARFILES) $(J2GPP_ADAPTERS) $(J2GPP_FLAGS)



DESIGN_FILES  =
DESIGN_FILES += $(shell find $(RTL_GENERATED_DIR) -name '*.v' -o  -name '*.sv')
DESIGN_FILES += $(shell find $(DEPENDENCIES_DIR)/AnyV-Generics/design/ -name '*.v' -o  -name '*.sv')

DESIGN_TOP_MODULE = axi_injector
DESIGN_TOP_FILE   = $(RTL_GENERATED_DIR)/$(DESIGN_TOP_MODULE).sv



VERILATOR_OUTPUT_DIR   = $(BUILD_DIR)/verilated/
VERILATOR_INCLUDE_DIRS = $(DESIGN_GENERATED_DIR)
VERILATOR_INCLUDE_ARG  = $(addprefix +incdir+, $(VERILATOR_INCLUDE_DIRS))
VERILATOR_FLAGS        = --binary -O3 -j 0 -Wall -Wno-UNSIGNED --Mdir $(VERILATOR_OUTPUT_DIR)



TESTCASES_DIR    = $(VERIFICATION_GENERATED_DIR)/testcases/
BASETEST         = base_test
BASETEST_DIR     = $(TESTCASES_DIR)/base_test
# Add base_test directory to have more than 2 arguments, otherwise basename doesn't work the same way
TESTCASES        = $(filter-out $(BASETEST),$(shell basename $(BASETEST_DIR) $(wildcard $(TESTCASES_DIR)/*/)))
export TESTCASES_DIR

TESTBENCH_TOP_MODULE = axi_injector_tb
TESTBENCH_TOP_FILE   = $(VERIFICATION_GENERATED_DIR)/testbench/$(TESTBENCH_TOP_MODULE).sv

VERIFICATION_SIMULATOR    = icarus
VERIFICATION_DUT          = $(TESTBENCH_TOP_MODULE)
VERIFICATION_DESIGN_FILES = $(DESIGN_FILES) $(TESTBENCH_TOP_FILE)

export VERIFICATION_SIMULATOR
export VERIFICATION_DUT
export VERIFICATION_DESIGN_FILES



# TESTCASE ?= base_test



WAVES_DIR = $(MAKE_DIR)/waves
WAVE_TOOL = gtkwave
WAVE_ARGS =



PYTHON      = python3.11

DATE_CMD = date -u +"%Y/%m/%d-%T"
TIME_LOG = $(BUILD_DIR)/make_time.log
export TIME_LOG

.PHONY: build
build: $(J2GPP_SOURCE_FILES)
	@echo "  ███████████              ███  ████      █████ "
	@echo " ░░███░░░░░███            ░░░  ░░███     ░░███  "
	@echo "  ░███    ░███ █████ ████ ████  ░███   ███████  "
	@echo "  ░██████████ ░░███ ░███ ░░███  ░███  ███░░███  "
	@echo "  ░███░░░░░███ ░███ ░███  ░███  ░███ ░███ ░███  "
	@echo "  ░███    ░███ ░███ ░███  ░███  ░███ ░███ ░███  "
	@echo "  ███████████  ░░████████ █████ █████░░████████ "
	@echo " ░░░░░░░░░░░    ░░░░░░░░ ░░░░░ ░░░░░  ░░░░░░░░  "
	mkdir -p $(BUILD_DIR)
	mkdir -p $(RESULTS_DIR)
	echo "build start" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG)
	j2gpp $(J2GPP_ARGUMENTS)
	echo "build end" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG)

.PHONY: verilate
verilate: $(DESIGN_FILES)
	echo "verilate start" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG)
	verilator $(DESIGN_TOP_FILE) $(VERILATOR_FLAGS) $(VERILATOR_INCLUDE_ARG)
	echo "verilate end" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG)

.PHONY: compile
compile:
	@echo "    █████████                                      ███  ████           "
	@echo "   ███░░░░░███                                    ░░░  ░░███           "
	@echo "  ███     ░░░   ██████  █████████████   ████████  ████  ░███   ██████  "
	@echo " ░███          ███░░███░░███░░███░░███ ░░███░░███░░███  ░███  ███░░███ "
	@echo " ░███         ░███ ░███ ░███ ░███ ░███  ░███ ░███ ░███  ░███ ░███████  "
	@echo " ░░███     ███░███ ░███ ░███ ░███ ░███  ░███ ░███ ░███  ░███ ░███░░░   "
	@echo "  ░░█████████ ░░██████  █████░███ █████ ░███████  █████ █████░░██████  "
	@echo "   ░░░░░░░░░   ░░░░░░  ░░░░░ ░░░ ░░░░░  ░███░░░  ░░░░░ ░░░░░  ░░░░░░   "
	@echo "                                        ░███                           "
	@echo "                                        █████                          "
	@echo "                                       ░░░░░                           "
	echo "compile start" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG)
	make -C $(TESTCASES_DIR)/$(BASETEST)/
	for TESTCASE in $(TESTCASES); do \
		cp -R $(TESTCASES_DIR)/$(BASETEST)/sim_build/ $(TESTCASES_DIR)/$$TESTCASE/sim_build/ ; \
	done
	echo "compile end" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG)

.PHONY: verify
verify:
	@echo "  █████   █████                     ███     ██████             "
	@echo " ░░███   ░░███                     ░░░     ███░░███            "
	@echo "  ░███    ░███   ██████  ████████  ████   ░███ ░░░  █████ ████ "
	@echo "  ░███    ░███  ███░░███░░███░░███░░███  ███████   ░░███ ░███  "
	@echo "  ░░███   ███  ░███████  ░███ ░░░  ░███ ░░░███░     ░███ ░███  "
	@echo "   ░░░█████░   ░███░░░   ░███      ░███   ░███      ░███ ░███  "
	@echo "     ░░███     ░░██████  █████     █████  █████     ░░███████  "
	@echo "      ░░░       ░░░░░░  ░░░░░     ░░░░░  ░░░░░       ░░░░░███  "
	@echo "                                                     ███ ░███  "
	@echo "                                                    ░░██████   "
	@echo "                                                     ░░░░░░    "
ifndef TESTCASE
	for TESTCASE in $(TESTCASES); do \
		echo "$$TESTCASE start" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG) ; \
		make -C $(TESTCASES_DIR)/$$TESTCASE ; \
		echo "$$TESTCASE end" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG) ; \
	done
else
	echo "$(TESTCASE) start" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG) ;
	make -C $(TESTCASES_DIR)/$(TESTCASE) ;
	echo "$(TESTCASE) end" >> $(TIME_LOG) ; $(DATE_CMD) >> $(TIME_LOG) ;
endif

.PHONY: report
report:
	$(PYTHON) $(SCRIPTS_DIR)/generate_maketime_report/generate_maketime_report.py

.PHONY: waves
waves:
ifdef TESTCASE
	$(WAVE_TOOL) $(WAVES_DIR)/$(TESTCASE).gtkw $(WAVES_ARGS)
else
	@echo "ERROR: Please specify the testcase with the variable TESTCASE."
endif

.PHONY: clean
clean:
	rm -rf $(GENERATED_DIR)
	rm -rf $(BUILD_DIR)
	rm -rf $(RESULTS_DIR)

