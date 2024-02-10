
import cocotb
from cocotb.handle import SimHandleBase

from verification.software.axi_injector import *

start_address     = 0x000
end_address       = 0xFFF
increment_address =   0x1

@cocotb.test()
async def injection_test(dut:SimHandleBase):
  injector = AXIInjector_TestBench(dut)
  await injector.initialize_testbench()



  # Configure single read
  await injector.configure_injection(
    address_generation_mode = InjectionAddressGenerationMode.RANGE,
    address_range_start     = start_address,
    address_range_stop      = end_address,
    address_range_increment = increment_address,
    transaction_direction   = InjectionTransactionDirection.READ,
    transaction_length      = 1,
    transaction_size        = InjectionTransactionSize._32B,
  )
  await injector.wait_signal_propagation()
  await injector.start_injection()
  await injector.wait_injection_finish()
  await injector.wait_reception_finish()



  await injector.reset_injection()
