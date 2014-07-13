module Difference
  class Base
    attr_reader :a, :b
    def initialize(a,b)
      @a = a
      @b = b
    end

    def base_equal(o)
      o and o.class == self.class and a == o.a and b == o.b
    end

    def ==(o)
      raise "equality via '==' not implemented for #{self.class.name}"
    end

    alias_method :eq, :==

    def to_s
      inspect
    end

    def inspect
      "#{a.inspect}->#{b.inspect}"
    end
  end
end
