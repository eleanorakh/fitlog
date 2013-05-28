class Workout
  include DataMapper::Resource

  property :id, Serial
  property :exercise_type, String
  property :exercise_duration, Integer

  belongs_to :user
end
