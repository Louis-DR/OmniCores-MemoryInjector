
def break_to_words(block, word_size=16):
  word_capacity = 2 ** word_size
  full_words = block // word_capacity
  leftover = block - word_capacity * full_words
  return full_words * [word_capacity] + [leftover]

def padd_array(array, padding_length=0, padding_value=''):
  return array + [padding_value] * (padding_length - len(array))

def clamp(value, lower_bound, upper_bound):
  return max(lower_bound, min(value, upper_bound))
