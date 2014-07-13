require_relative 'difference/base'
require_relative 'difference/scalar_diff'
require_relative 'difference/hash_diff'
require_relative 'difference/array_diff'

require_relative 'difference/strategy/scalar_strategy'
require_relative 'difference/strategy/hash_strategy'
require_relative 'difference/strategy/array_strategy'

module Difference
  class << self
    # def add_strategy(strategy)
    #   strategies << strategy
    # end

    def strategies
      @strategies ||= [
        Strategy::HashStrategy.new,
        Strategy::ArrayStrategy.new,
        Strategy::ScalarStrategy.new,
      ]
    end
    
    # def default_strategy
    #   @default_strategy ||= Strategy::ScalarStrategy.new
    # end

    def diff(a,b)
      strategies.each do |strategy|
        if strategy.applies_to(a,b)
          return strategy.execute(a,b)
        end
      end
      raise "Couldn't find applicable strategy for #{a.inspect} #{b.inspect}"
    end

  end
end

