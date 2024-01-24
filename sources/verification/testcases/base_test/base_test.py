
import cocotb
from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.triggers import ClockCycles

import cocotbext.apb as apb

@cocotb.test()
async def base_test(dut:SimHandleBase):
  master = apb.APBMasterDriver(dut, "control", dut.control_pclk, uppercase=False)

  cocotb.start_soon(Clock(dut.control_pclk, 10, units="ns").start())
  cocotb.start_soon(Clock(dut.data_aclk, 1, units="ns").start())

  await ClockCycles(dut.control_pclk, 20)

  transaction = apb.APBTransaction(address = 0xDEADBEEF,
                                   data    = 0x12345678)
  transaction.print()

  await master.send(transaction)

  await ClockCycles(dut.control_pclk, 20)
