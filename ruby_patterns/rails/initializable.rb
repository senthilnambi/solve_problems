# Originally from railties/lib/rails/initializable.rb
#
# Changes:
#   * Moved methods around so same context methods clumped together
#   * Renamed `@ran` to `@initializer_ran` in `run_initializers`
#   * Cut up methods into logical paragraphs
#   * Added `initializer_ran?`
#   * Switched to checking truthiness of `initializer_ran?` from checking if `@initializer_ran` was defined in `run_initializers`
#   * Renamed local varable `initializers` to `inits_collection` in `initializers_chain` so we don't confuse it with `initializers` method
#   * Switched Initializer#bind to return self from new instance, not sure why it did

require 'tsort'

module Initializable
  def self.included(base)
    base.extend ClassMethods
  end

  def run_initializers(group=:default, *args)
    return false if initializer_ran?

    initializers.tsort.each do |initializer|
      initializer.run(*args) if initializer.belongs_to?(group)
    end

    @initializer_ran = true
  end

  def initializers
    @initializers ||= self.class.initializers_for(self)
  end

  def initializer_ran?
    !!@initializer_ran
  end

  module ClassMethods
    def initializer(name, opts = {}, &blk)
      raise ArgumentError, "A block must be passed when defining an initializer" unless blk

      opts[:after] ||= initializers.last.name unless initializers.empty? || initializers.find { |i| i.name == opts[:before] }

      initializers << Initializer.new(name, nil, opts, &blk)
    end

    def initializers
      @initializers ||= Collection.new
    end

    def initializers_chain
      inits_collection = Collection.new
      ancestors.reverse_each do |klass|
        next unless klass.respond_to?(:initializers)
        inits_collection = inits_collection + klass.initializers
      end

      inits_collection
    end

    def initializers_for(binding)
      Collection.new(initializers_chain.map { |i| i.bind(binding) })
    end
  end

  class Initializer
    attr_reader :name, :block, :context

    def initialize(name, context, options, &block)
      options[:group] ||= :default
      @name, @context, @options, @block = name, context, options, block
    end

    # not DRY, but is metaprogramming required for so little code?
    def before
      @options[:before]
    end

    def after
      @options[:after]
    end

    def belongs_to?(group)
      @options[:group] == group || @options[:group] == :all
    end

    def run(*args)
      @context.instance_exec(*args, &block)
    end

    def bind(context)
      return self if @context

      @context = context

      self
    end
  end

  class Collection < Array
    include TSort

    alias :tsort_each_node :each
    def tsort_each_child(initializer, &block)
      select { |i| i.before == initializer.name || i.name == initializer.after }.each(&block)
    end

    def +(other)
      Collection.new(to_a + other.to_a)
    end
  end
end
