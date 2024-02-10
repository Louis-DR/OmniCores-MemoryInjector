
import cocotb
from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.triggers import ClockCycles

import cocotbext.apb as apb

from verification.software.axi_injector import *

access_address = 0xBABE

@cocotb.test()
async def single_read_write_read_test(dut:SimHandleBase):
  injector = AXIInjector_TestBench(dut)
  await injector.initialize_testbench()



  # Configure single read
  await injector.configure_injection(
    address_generation_mode = InjectionAddressGenerationMode.RANGE,
    address_range_start     = access_address,
    address_range_stop      = access_address,
    address_range_increment = 0x1,
    transaction_direction   = InjectionTransactionDirection.READ,
    transaction_length      = 1,
    transaction_size        = InjectionTransactionSize._32B,
  )
  await injector.wait_signal_propagation()
  await injector.start_injection()
  await injector.wait_injection_finish()




  # Configure single write
  await injector.reset_injection()
  await injector.configure_injection(
    address_generation_mode = InjectionAddressGenerationMode.RANGE,
    address_range_start     = access_address,
    address_range_stop      = access_address,
    address_range_increment = 0x1,
    data_generation_mode    = InjectionDataGenerationMode.RANDOM,
    data_initial_value      = 0xDEADBEEF,
    transaction_direction   = InjectionTransactionDirection.WRITE,
    transaction_length      = 1,
    transaction_size        = InjectionTransactionSize._32B,
  )
  await injector.wait_signal_propagation()
  await injector.start_injection()
  await injector.wait_injection_finish()



  # Configure single read
  await injector.reset_injection()
  await injector.configure_injection(
    address_generation_mode = InjectionAddressGenerationMode.RANGE,
    address_range_start     = access_address,
    address_range_stop      = access_address,
    address_range_increment = 0x1,
    transaction_direction   = InjectionTransactionDirection.READ,
    transaction_length      = 1,
    transaction_size        = InjectionTransactionSize._32B,
  )
  await injector.wait_signal_propagation()
  await injector.start_injection()
  await injector.wait_injection_finish()



  await injector.reset_injection()



  await ClockCycles(dut.control_pclock, 100)
