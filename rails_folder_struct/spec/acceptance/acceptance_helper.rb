require_relative '../spec_helper'
require 'rack/test'

def app
  $app ||= GitStat.initialize!
end

include Rack::Test::Methods
