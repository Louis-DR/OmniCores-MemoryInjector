
def register_bank_adapter(vars):
  for register in vars['registers']:
    if 'fields' in register:
      # Add the offset for register fields
      field_offset = 0
      for field in register['fields']:
        field['offset'] = field_offset
        field_offset += field['width']
