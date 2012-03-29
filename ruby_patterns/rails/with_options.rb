# Originally from activesupport/lib/active_support/options_merger.rb
#
# Changes:
#   * OptionMerger now inherits from BasicObject, no need to `undef` stuff
#   * Changed `Proc` to `::Proc`
#   * Cut lines to fit 72 characters

class Hash
  def deep_merge(other_hash)
    dup.deep_merge!(other_hash)
  end

  def deep_merge!(other_hash)
    other_hash.each_pair do |k,v|
      tv = self[k]
      self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_merge(v) : v
    end
    self
  end
end

class OptionMerger < BasicObject
  #instance_methods.each do |method|
    #undef_method(method) if method !~
    #/^(__|instance_eval|class|object_id)/
  #end

  def initialize(context, options)
    @context, @options = context, options
  end

  private

  def method_missing(method, *arguments, &block)
    if arguments.last.is_a?(::Proc)
      proc = arguments.pop

      arguments << lambda do |*args|
        @options.deep_merge(proc.call(*args))
      end
    else
      arguments << if arguments.last.respond_to?(:to_hash)
        @options.deep_merge(arguments.pop)
      else
        @options.dup
      end
    end

    @context.__send__(method, *arguments, &block)
  end
end

class Object
  def with_options(options)
    yield OptionMerger.new(self, options)
  end
end

describe OptionMerger do
  let(:name) {{ :name => 'last crusade' }}
  let(:hook) {{ :hook => 'holy grail'  }}
  let(:villan) { lambda {{ :villan => 'nazis' }}}

  def dummy_method(opts={})
    opts
  end

  it 'inherits parent options' do
    with_options(name) do |mov|
      mov.dummy_method.should == name
    end
  end

  it 'merges parent options with hash args' do
    with_options(name) do |mov|
      mov.dummy_method(hook).should == name.merge(hook)
    end
  end

  it 'merges parent options with proc args' do
    with_options(name) do |mov|
      mov.dummy_method(villan.call).should == name.merge(villan.call)
    end
  end

  it 'merges nested parent options' do
    with_options(name) do |outer|
      outer.with_options(hook) do |mov|
        mov.dummy_method.should == name.merge(hook)
      end
    end
  end
end
