
import cocotb
from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.triggers import ClockCycles

import cocotbext.apb as apb

@cocotb.test()
async def register_test(dut:SimHandleBase):
  master = apb.APBMasterDriver(dut, "control", dut.control_pclk, uppercase=False)

  cocotb.start_soon(Clock(dut.control_pclk, 10, units="ns").start())
  cocotb.start_soon(Clock(dut.data_aclk, 1, units="ns").start())

  dut.control_presetn.value = 0
  await ClockCycles(dut.control_pclk, 2)
  dut.control_presetn.value = 1
  await ClockCycles(dut.control_pclk, 2)

  await ClockCycles(dut.control_pclk, 20)

  transaction = apb.APBTransaction(address = 0x0)
  await master.busy_send(transaction)
  transaction.print()

  await ClockCycles(dut.control_pclk, 2)

  transaction = apb.APBTransaction(address = 0x0, data = 0x12345678)
  await master.busy_send(transaction)
  transaction.print()

  await ClockCycles(dut.control_pclk, 2)

  transaction = apb.APBTransaction(address = 0x0)
  await master.busy_send(transaction)
  transaction.print()

  await ClockCycles(dut.control_pclk, 20)
