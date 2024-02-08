
import cocotb
from cocotb.clock import Clock
from cocotb.handle import SimHandleBase
from cocotb.triggers import ClockCycles

import cocotbext.apb as apb
import cocotbext.axi as axi

from verification.software.axi_injector import *

access_address = 0xBABE

@cocotb.test()
async def single_read_write_read_test(dut:SimHandleBase):
  apb_master = apb.APBMasterDriver(dut, "control", dut.control_pclock, uppercase=False)
  axi_ram    = axi.AxiRam(axi.AxiBus.from_prefix(dut, "data"), dut.data_aclock, dut.data_aresetn, size=2**48, reset_active_level=False)

  cocotb.start_soon(Clock(dut.control_pclock, 10, units="ns").start())
  cocotb.start_soon(Clock(dut.data_aclock, 1, units="ns").start())



  # Reset the injector
  dut.control_presetn.value = 0
  dut.data_aresetn.value = 0
  await ClockCycles(dut.control_pclock, 2)
  dut.control_presetn.value = 1
  dut.data_aresetn.value = 1
  await ClockCycles(dut.control_pclock, 10)



  # Configure for single read
  await apb_master.busy_send(apb.APBTransaction(address = csr__injection_mode__address,            data = 0x0            )) # Range address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_start_0__address,     data = access_address )) # Start address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_stop_0__address,      data = access_address )) # Start address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_increment_0__address, data = 0x1            )) # Address increment
  await apb_master.busy_send(apb.APBTransaction(address = csr__transaction_attributes__address,    data = 0x0            )) # Read transaction

  # Wait
  await ClockCycles(dut.control_pclock, 5)

  # Start
  await apb_master.busy_send(apb.APBTransaction(address = csr__control__address, data = 0x1)) # Start

  # Wait until injection is done
  pooling_iterations = 100
  while pooling_iterations != 0:
    transaction = apb.APBTransaction(address = csr__status__address) # Status
    await apb_master.busy_send(transaction)
    if ((transaction.data & 0b11) == 0b11):
      break
    pooling_iterations -= 1



  # Reset
  await apb_master.busy_send(apb.APBTransaction(address = csr__control__address, data = 0x0)) # Reset



  # Configure for writes
  await apb_master.busy_send(apb.APBTransaction(address = csr__injection_mode__address,            data = 0x0 | 0x1 << 1 )) # Range address & random data
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_start_0__address,     data = access_address )) # Start address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_stop_0__address,      data = access_address )) # Start address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_increment_0__address, data = 0x1            )) # Address increment
  await apb_master.busy_send(apb.APBTransaction(address = csr__data_initial_value_0__address,      data = 0xDEADBEEF     )) # Initial random data seed
  await apb_master.busy_send(apb.APBTransaction(address = csr__transaction_attributes__address,    data = 0x1            )) # Write transaction

  # Wait
  await ClockCycles(dut.control_pclock, 5)

  # Start
  await apb_master.busy_send(apb.APBTransaction(address = csr__control__address, data = 0x1)) # Start

  # Wait until injection is done
  pooling_iterations = 100
  while pooling_iterations != 0:
    transaction = apb.APBTransaction(address = csr__status__address) # Status
    await apb_master.busy_send(transaction)
    if ((transaction.data & 0b11) == 0b11):
      break
    pooling_iterations -= 1



  # Reset
  await apb_master.busy_send(apb.APBTransaction(address = csr__control__address, data = 0x0)) # Reset



  # Configure for single read
  await apb_master.busy_send(apb.APBTransaction(address = csr__injection_mode__address,            data = 0x0            )) # Range address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_start_0__address,     data = access_address )) # Start address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_stop_0__address,      data = access_address )) # Start address
  await apb_master.busy_send(apb.APBTransaction(address = csr__address_range_increment_0__address, data = 0x1            )) # Address increment
  await apb_master.busy_send(apb.APBTransaction(address = csr__transaction_attributes__address,    data = 0x0            )) # Read transaction

  # Wait
  await ClockCycles(dut.control_pclock, 5)

  # Start
  await apb_master.busy_send(apb.APBTransaction(address = csr__control__address, data = 0x1)) # Start

  # Wait until injection is done
  pooling_iterations = 100
  while pooling_iterations != 0:
    transaction = apb.APBTransaction(address = csr__status__address) # Status
    await apb_master.busy_send(transaction)
    if ((transaction.data & 0b11) == 0b11):
      break
    pooling_iterations -= 1



  # Reset
  await apb_master.busy_send(apb.APBTransaction(address = csr__control__address, data = 0x0)) # Reset



  await ClockCycles(dut.control_pclock, 100)