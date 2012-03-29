# Originally from 'railties/lib/rails/info.rb'
#
# Changes:
#   * Removed `require cgi`.
#   * Added `require 'activesupport/all'`
#   * Removed most methods to make it easier to understand.
#   * Added `extend self`, which removes need for `class << self` to define `property`
#
require 'active_support/core_ext/module/attribute_accessors'

module Info
  mattr_accessor :properties
  class << (@@properties = [])
    def names
      map {|val| val.first }
    end
  end

  extend self

  def property(name, value = nil)
    value ||= yield
    properties << [name, value] if value
  rescue Exception
  end

end

describe Info do
  subject do
    described_class.module_eval do
      property 'Ruby version', RUBY_VERSION

      property 'RubyGems version' do
        Gem::RubyGemsVersion
      end

      # BUG: does not rescue error if NonExistent is passed as argument
      property 'NonExistent' do
        NonExistent
      end
    end

    described_class
  end

  def find_property(name)
    subject.properties.find {|x| x[0] == name}
  end

  context 'when property is called' do
    it '(with String) returns Ruby version' do
      find_property('Ruby version')[1].should == '1.9.3'
    end

    it '(with block) returns RubyGems version' do
      find_property('RubyGems version')[1].should == '1.8.16'
    end

    it 'rescues non-existent property errors' do
      find_property('NonExistent').should == nil
    end
  end

  it 'defines methods by opening singleton class on a variable' do
    subject.properties.names.count.should == 2
  end
end
