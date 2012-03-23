require 'rails'
require 'action_controller/railtie'
require 'mongo_mapper'

MongoMapper.database = "git_stat_#{Rails.env}"

class GitStat < Rails::Application
  routes.append do
    post '/users' => 'users#create'
  end

  config.active_support.deprecation = :notify

  config.middleware.delete Rails::Rack::Logger
  config.middleware.delete Rails::Rack::LogTailer
  config.middleware.delete ActiveSupport::LogSubscriber

  config.middleware.delete Rack::ETag
  config.middleware.delete Rack::Lock
  config.middleware.delete ActionDispatch::Flash
  config.middleware.delete ActionDispatch::Cookies
  config.middleware.delete ActionDispatch::Callbacks
  config.middleware.delete ActionDispatch::BestStandardsSupport

  config.secret_token = '49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk'

  config.paths["log"] = "rails/log/#{Rails.env}.log"
end

require_relative '../users/user.rb'
require_relative '../users/users_controller.rb'
