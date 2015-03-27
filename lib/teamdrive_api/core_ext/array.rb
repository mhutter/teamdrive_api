class Array
  # Returns an Array with all elements' keys converted to symbols, as long as
  # they respond to +symbolize_keys+.
  def symbolize_keys
    self.map { |e| e.symbolize_keys rescue e }
  end

  # Converts the keys of all elements to symbols, as long as the elements
  # respond to +symbolize_keys!+
  def symbolize_keys!
    self.each do |e|
      e.symbolize_keys! rescue nil
    end
  end
end
