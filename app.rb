$: << 'lib'

require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

require 'user'

DataMapper.finalize.auto_upgrade!

get '/users' do
  User.all.map do |user|
    user.name || 'unknown'
  end.join(', ')
end
