require './git_stat'

GitStat.initialize!

puts ">> Starting Rails lightweight stack"
Rails.configuration.middleware.each do |middleware|
  puts "use #{middleware.inspect}"
end
puts "run #{Rails.application.class.name}.routes"

#puts Rails.configuration.inspect

run GitStat
