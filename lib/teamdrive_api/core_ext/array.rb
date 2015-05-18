class Array # :nodoc:
  # Returns an Array with all elements' keys converted to symbols, as long as
  # they respond to +symbolize_keys+.
  def symbolize_keys
    map { |e| e.respond_to?(:symbolize_keys) ? e.symbolize_keys : e }
  end

  # Converts the keys of all elements to symbols, as long as the elements
  # respond to +symbolize_keys!+
  def symbolize_keys!
    each do |e|
      e.symbolize_keys! if e.respond_to?(:symbolize_keys!)
    end
  end
end
