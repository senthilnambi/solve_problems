# Originally from lib/active_support/lazy_load_hooks.rb
#
# Changes:
#   * Added `extend self`, no need for `self` prefix
#   * Added `attr_accessor` for `@load_hooks` and `@loaded_bases`
#   * Using Set to avoid identical bases
#   * Renamed `@loaded` to `@loaded_bases`
#   * Added `reset` method

require 'set'

module LazyLoadHook
  extend self

  attr_accessor :load_hooks, :loaded_bases

  @load_hooks   = Hash.new { |h,k| h[k] = [] }
  @loaded_bases = Hash.new { |h,k| h[k] = Set.new }

  def on_load(name, options = {}, &block)
    @loaded_bases[name].each do |base|
      execute_hook(base, options, block)
    end

    @load_hooks[name] << [block, options]
  end

  def execute_hook(base, options, block)
    # line not tested
    if options[:yield]
      block.call(base)
    else
      base.instance_eval(&block)
    end
  end

  def run_load_hooks(name, base = Object)
    @loaded_bases[name] << base

    @load_hooks[name].each do |hook, options|
      execute_hook(base, options, hook)
    end
  end

  def reset
    @load_hooks.clear
    @loaded_bases.clear
  end
end

describe LazyLoadHook do
  subject { described_class }

  class Counter
    attr_accessor :number

    def initialize(number)
      @number = number
    end

    def reset
      @number = 0
    end
  end

  let(:counter) { Counter.new(0) }

  def add_hook
    subject.on_load(:start) { self.number += 1 }
  end

  def run_hooks
    subject.run_load_hooks(:start, counter)
  end

  after do
    counter.reset
    described_class.reset
  end

  it 'runs hooks lazily only when base is loaded' do
    add_hook
    counter.number.should == 0
  end

  it 'does not load identical bases' do
    add_hook
    2.times { run_hooks }

    described_class.loaded_bases.count.should == 1
  end

  it 'runs hooks with yield option' do
    blk = proc { |countr| countr.number+= 1 }
    described_class.execute_hook(counter, {:yield => true}, blk)

    counter.number.should == 1
  end

  context 'when base is loaded' do
    before do
      add_hook
      run_hooks
    end

    it 'runs all hooks' do
      counter.number.should == 1
    end

    it 'runs new hook immediately' do
      add_hook
      counter.number.should == 2
    end
  end
end
