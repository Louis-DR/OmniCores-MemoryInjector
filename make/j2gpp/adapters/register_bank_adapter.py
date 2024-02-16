
def register_bank_adapter(vars):
  register_offset = 0
  previous_offset = 0
  for register in vars['registers']:
    if 'offset' in register:
      register_offset = register['offset']
    elif 'align' in register:
      register_offset = (register_offset // register['align'] + 1) * register['align']
      register['offset'] = register_offset
    else:
      register['offset'] = register_offset
    register_offset += 4

    if register['offset'] != 0:
      padding_before = register['offset'] - previous_offset - 4
      if padding_before:
        register['padding_before'] = padding_before
      previous_offset = register['offset']

    if 'fields' in register:
      # Add the offset for register fields
      field_offset = 0
      for field in register['fields']:
        field['offset'] = field_offset
        field_offset += field['width']