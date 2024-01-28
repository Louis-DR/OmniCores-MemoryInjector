def hexadecimal(value):
  return f"{value:X}"

def arrsize(size):
  """
  Generates the `[size-1:0]` signal array size definition if `size>1`,
  else it returns an empty string.
  """
  if size == 1:
    return ""
  else:
    return f"[{size-1}:0]"
