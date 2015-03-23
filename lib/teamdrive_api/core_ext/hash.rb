class Hash
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
    each_key do |key|
      new_key = key.to_sym rescue key
      new_value = self[key].symbolize_keys rescue self[key]
      result[new_key] = new_value
    end
    result
  end

  # Destructively converts all keys to symbols, as long as they respond
  # to +to_sym+. Same as +symbolize_keys+, but modifies +self+.
  #
  # Borrowed from ActiveSupport.
  def symbolize_keys!
    keys.each do |key|
      new_key = key.to_sym rescue key
      old_value = delete(key)
      new_value = old_value.symbolize_keys! rescue old_value
      self[new_key] = new_value
    end
    self
  end
end
