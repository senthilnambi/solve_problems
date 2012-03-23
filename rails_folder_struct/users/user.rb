class User
  include MongoMapper::Document

  key :github_id, String
end
