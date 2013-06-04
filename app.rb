$: << 'lib'

require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

require 'user'
require 'workout'

DataMapper.finalize.auto_upgrade!

get '/users' do
  @users = User.all
  erb :index
end

get '/users/:id' do
  User.get(params[:id]).name || 'unknown'
end

get '/users/:user_id/workouts' do
  user = User.get(params[:user_id])
  user.workouts.map do |workout|
    workout.exercise_type
  end.join ', '
end

get '/users/:user_id/workouts/:id' do
  Workout.get(params[:id]).exercise_type
end
