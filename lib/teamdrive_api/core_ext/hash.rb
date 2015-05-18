class Hash # :nodoc:
  # Returns a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+.
  #
  #   hash = { 'name' => 'Rob', 'age' => '28' }
  #
  #   hash.symbolize_keys
  #   # => {:name=>"Rob", :age=>"28"}
  #
  # Borrowed from ActiveSupport.
  def symbolize_keys
    result = self.class.new
    each do |key, val|
      new_key = key.respond_to?(:to_sym) ? key.to_sym : key
      new_value = val.respond_to?(:symbolize_keys) ? val.symbolize_keys : val
      result[new_key] = new_value
    end
    result
  end

  # Destructively converts all keys to symbols, as long as they respond
  # to +to_sym+. Same as +symbolize_keys+, but modifies +self+.
  #
  # Borrowed from ActiveSupport.
  def symbolize_keys!
    # we have to use `keys.each` because we can't modify a Hash during `each`
    keys.each do |key|
      new_key = key.respond_to?(:to_sym) ? key.to_sym : key
      val = delete(key)
      new_value = val.respond_to?(:symbolize_keys!) ? val.symbolize_keys! : val
      self[new_key] = new_value
    end
    self
  end
end
