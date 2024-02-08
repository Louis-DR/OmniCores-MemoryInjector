
import cocotbext.apb as apb

from verification.software.utils import clamp

class APBRegisterField:
  def __init__(self, offset, width):
    self.offset = offset
    self.width  = width

class APBRegister:
  def __init__(self, apb_master:apb.APBMasterDriver, address:int, value:int=0x0, fields:dict[str,APBRegisterField]=None):
    self.apb_master = apb_master
    self.address    = address
    self.value      = value
    self.dirty      = True
    self.fields     = fields

  def add_field(self, field_name:str, field_descriptor:APBRegisterField) -> None:
    if self.fields is None:
      self.fields = {field_name : field_descriptor}
    else:
      self.fields[field_name] = field_descriptor

  async def read(self) -> int:
    transaction = apb.APBTransaction(address = self.address)
    await self.apb_master.busy_send(transaction)
    if transaction.error:
      raise Exception("Slave error")
    self.value = transaction.data
    self.dirty = False
    return transaction.data

  async def write(self, data:int) -> None:
    transaction = apb.APBTransaction(address = self.address, data = data)
    await self.apb_master.busy_send(transaction)
    if transaction.error:
      raise Exception("Slave error")
    else:
      self.value = data
      self.dirty = False

  def non_blocking_write(self, data:int) -> None:
    transaction = apb.APBTransaction(address = self.address, data = data)
    self.apb_master.send(transaction)
    self.value = data
    self.dirty = False

  def modify(self, value:int) -> None:
    if value != self.value:
      self.value = value
      self.dirty = True

  def modify_field(self, field_name:str, value:int) -> None:
    field_descriptor = self.fields[field_name]
    value = clamp(value, 0, 2 ** field_descriptor.width)
    value_old = self.value
    self.value &= value << field_descriptor.offset
    if self.value != value_old:
      self.dirty = True

  async def update(self) -> None:
    if self.dirty:
      await self.write(self.value)

  def non_blocking_update(self) -> None:
    if self.dirty:
      self.non_blocking_write(self.value)
