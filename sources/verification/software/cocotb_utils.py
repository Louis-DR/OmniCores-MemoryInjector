
import cocotbext.apb as apb

class APBRegister:
  def __init__(self, apb_master:apb.APBMasterDriver, address:int, value:int=None):
    self.apb_master = apb_master
    self.address    = address
    self.value      = value

  async def read(self) -> int:
    transaction = apb.APBTransaction(address = self.address)
    await self.apb_master.busy_send(transaction)
    if transaction.error:
      raise Exception("Slave error")
    return transaction.data

  async def write(self, data:int) -> None:
    transaction = apb.APBTransaction(address = self.address, data = data)
    await self.apb_master.busy_send(transaction)
    if transaction.error:
      raise Exception("Slave error")

  def non_blocking_write(self, data:int) -> None:
    transaction = apb.APBTransaction(address = self.address, data = data)
    self.apb_master.send(transaction)
