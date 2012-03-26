require_relative 'initializable'

class DummyBlog
  include Initializable

  initializer :default do
    'hi'
  end
end

class DummyPost < DummyBlog
  attr_accessor :count

  def initialize
    @count = 0
  end

  initializer :default do
    self.count += 1
  end
end

def post_const
  DummyPost
end

def blog_const
  DummyBlog
end

module Initializable
  describe Initializable do
    subject { post_const.new }

    let(:run_default_initializer) do
      subject.run_initializers
    end

    it 'raises error if not block is given' do
      expect do
        post_const.class_eval { initializer '' }
      end.to raise_error
    end

    # testing implementation
    # check to see initializers ran from parent & child
    it 'inherits initializers from parent class' do
      subject.initializers.count.should == 2
    end

    # testing implementation?
    it 'sorts various initializers'

    # testing implementation
    it 'binds self as context to own/parent class initializers'

    it 'runs initalizers only for specified group'
    it 'runs initializers only once'
    it 'runs other than :default groups'
    it 'runs initializers with args'
    it 'app is passed as argument to block'
    it 'merges initializers from parent in right order'

    context 'when initializer has not run' do
      it 'boolean returns false' do
        subject.initializer_ran?.should == false
      end
    end

    context 'when initializer has run' do
      before { subject.run_initializers }

      it 'return true if successful' do
        subject.instance_variable_set(:@initializer_ran, false)
        run_default_initializer.should == true
      end

      it 'returns false if initializer has already run' do
        run_default_initializer.should == false
      end

      it 'executes block code' do
        subject.count == 1
      end

      it 'sets boolean to inidicate ran status' do
        subject.initializer_ran?.should == true
      end
    end
  end

  describe Initializer do
    def init(context)
      described_class.new(:middle, context, {}) do
        self.count += 1
      end
    end

    subject { init(post_instance) }

    let(:post_instance) { post_const.new }

    context 'when no context' do
      it 'binds passed in context' do
        initializer = init(nil).bind(post_instance)
        initializer.context.should == post_instance
      end
    end

    context 'when context' do
      it 'returns self if we try to bind another context' do
        subject.bind(post_instance).should == subject
      end
    end

    it 'executes block code in context' do
      subject.run
      post_instance.count.should == 1
    end
  end
end
