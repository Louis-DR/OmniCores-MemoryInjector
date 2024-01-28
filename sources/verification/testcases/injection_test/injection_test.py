
import cocotb
from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.triggers import ClockCycles

import cocotbext.apb as apb

@cocotb.test()
async def injection_test(dut:SimHandleBase):
  master = apb.APBMasterDriver(dut, "control", dut.control_pclk, uppercase=False)

  cocotb.start_soon(Clock(dut.control_pclk, 10, units="ns").start())
  cocotb.start_soon(Clock(dut.data_aclk, 1, units="ns").start())

  # Stub the AXI port
  dut.data_awready.value = 1
  dut.data_wready.value  = 1
  dut.data_bid.value     = 0
  dut.data_bresp.value   = 0
  dut.data_bvalid.value  = 1
  dut.data_arready.value = 1
  dut.data_rid.value     = 0
  dut.data_rdata.value   = 0
  dut.data_rresp.value   = 0
  dut.data_rlast.value   = 0
  dut.data_rvalid.value  = 1

  dut.control_presetn.value = 0
  dut.data_aresetn.value = 0
  await ClockCycles(dut.control_pclk, 2)
  dut.control_presetn.value = 1
  dut.data_aresetn.value = 1
  await ClockCycles(dut.control_pclk, 2)

  await ClockCycles(dut.control_pclk, 20)

  # Configure
  await master.busy_send(apb.APBTransaction(address =  0xC, data =    0x1)) # Injection mode
  await master.busy_send(apb.APBTransaction(address = 0x10, data = 0x1000)) # Start address
  await master.busy_send(apb.APBTransaction(address = 0x18, data = 0x2000)) # Stop address
  await master.busy_send(apb.APBTransaction(address = 0x20, data =   0x20)) # Address increment

  await ClockCycles(dut.control_pclk, 5)

  # Start
  await master.busy_send(apb.APBTransaction(address =  0x4, data =    0x1)) # Start

  await ClockCycles(dut.control_pclk, 5)

  # Wait until injection is done
  pooling_iterations = 100
  while pooling_iterations != 0:
    transaction = apb.APBTransaction(address = 0x8) # Status
    await master.busy_send(transaction)
    if ((transaction.data & 0b11) == 0b11):
      break
    pooling_iterations -= 1

  await ClockCycles(dut.control_pclk, 10)

  # Reset
  await master.busy_send(apb.APBTransaction(address =  0x4, data =    0x0)) # Reset

  await ClockCycles(dut.control_pclk, 100)
