
import cocotb
from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.triggers import ClockCycles

@cocotb.test()
async def base_test(dut:SimHandleBase):
  cocotb.start_soon(Clock(dut.control_pclk, 10, units="ns").start())
  await ClockCycles(dut.control_pclk, 10)
