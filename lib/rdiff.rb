require 'set'

class Diff
  attr_reader :a, :b
  def initialize(a,b)
    @a = a
    @b = b
  end
  def changes
    []
  end
end

class HashDiff < Diff
  def initialize(a,b,diffs,added,lost)
    super a,b
    @diffs = diffs
    @added = added
    @lost = lost
    @changes = []
  end
  def changes
    @changes
  end
end

class ArrayDiff < Diff
  def initialize(a,b,adds,drops)
    super a,b
    @adds = adds
    @drops = drops
    @changes = []
  end
  def changes
    @changes
  end
end

def make_diff(a,b)
  Diff.new(a,b)
end

def make_hash_diff(a,b,diffs,adds,drops)
  HashDiff.new(a,b,diffs,adds,drops)
end

def make_array_diff(a,b,adds,drops)
  ArrayDiff.new(a,b,adds,drops)
end

def diff_scalar_value(a,b)
  if a != b
    make_scalar_diff a, b
  else
    nil
  end
end

def diff_hash(a,b)
  a_keys = a.keys
  b_keys = b.keys
  new_keys = b_keys - a_keys
  missing_keys = a_keys - b_keys
  shared_keys = (Set.new(a_keys) & Set.new(b_keys)).to_a.sort
  # all_keys = Set.new(a_keys + b_keys).to_a.sort

  adds = new_keys.map do |key| b[key] end
  drops = missing_keys.map do |key| a[key] end
  diffs = shared_keys.map do |key| 
    diff(a[key], b[key]) 
  end.reject do |d| 
    d.nil? 
  end

  if adds.empty? and drops.empty? and diffs.empty?
    nil
  else
    make_hash_diff a,b, diffs, adds, drops
  end
end

def diff_array(a,b)
  new_items = b - a
  missing_items = a - b
  if new_items.empty? and missing_items.empty?  
    nil
  else
    make_array_diff a,b, new_items, missing_items
  end
end

def diff(a,b)
  if Hash === a and Hash === b
    diff_hash(a, b)
  elsif Array === a and Array === b
    diff_array(a,b)
  else
    d = diff_scalar_value(a,b)
  end
end

__END__

DIFF:
  when a and b are Hash
  when a and b are Array
  else
    
