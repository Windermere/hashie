require 'wahashie/hash_extensions'

module Wahashie
  # A Wahashie Hash is simply a Hash that has convenience
  # functions baked in such as stringify_keys that may
  # not be available in all libraries.
  class Hash < Hash
    include Wahashie::HashExtensions

    # Converts a mash back to a hash.
    def to_hash(options = {})
      out = {}
      keys.each do |k|
        key = options[:symbolize_keys] ? k.to_sym : k.to_s
        out[key] = Wahashie::Hash === self[k] ? self[k].to_hash : self[k]
      end
      out
    end

    # The C geneartor for the json gem doesn't like mashies
    def to_json(*args)
      to_hash.to_json(*args)
    end
  end
end
