require_relative 'difference/base'
require_relative 'difference/scalar_diff'
require_relative 'difference/hash_diff'
require_relative 'difference/array_diff'

require_relative 'difference/strategy/scalar_strategy'
require_relative 'difference/strategy/hash_strategy'
require_relative 'difference/strategy/array_strategy'

module Difference
  class << self
    def default_strategies
      @strategies ||= [
        Strategy::HashStrategy.new,
        Strategy::ArrayStrategy.new,
        Strategy::ScalarStrategy.new,
      ]
    end

    def diff(a,b)
      diff_with_strategies a,b, default_strategies
    end
    
    def diff_with_strategies(a,b, strategies)
      strategies.each do |strategy|
        if strategy.applies_to(a,b)
          return strategy.execute(a,b)
        end
      end
      raise "No Strategy found that applies to (#{a.inspect}, #{b.inspect}) amongst #{strategies.map do |s| s.class end.inspect}"
    end

  end
end

