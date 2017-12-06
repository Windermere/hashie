module Wahashie
  module HashExtensions
    def self.included(base)
      # Don't tread on existing extensions of Hash by
      # adding methods that are likely to exist.
      %w(stringify_keys stringify_keys!).each do |wahashie_method|
        base.send :alias_method, wahashie_method, "wahashie_#{wahashie_method}" unless base.instance_methods.include?(wahashie_method)
      end
    end

    # Destructively convert all of the keys of a Hash
    # to their string representations.
    def wahashie_stringify_keys!
      self.keys.each do |k|
        unless String === k
          self[k.to_s] = self.delete(k)
        end
      end
      self
    end

    # Convert all of the keys of a Hash
    # to their string representations.
    def wahashie_stringify_keys
      self.dup.stringify_keys!
    end

    # Convert this hash into a Mash
    def to_mash
      ::Wahashie::Mash.new(self)
    end
  end

  module PrettyInspect
    def self.included(base)
      base.send :alias_method, :hash_inspect, :inspect
      base.send :alias_method, :inspect, :wahashie_inspect
    end

    def wahashie_inspect
      ret = "#<#{self.class.to_s}"
      stringify_keys.keys.sort.each do |key|
        ret << " #{key}=#{self[key].inspect}"
      end
      ret << ">"
      ret
    end
  end
end
