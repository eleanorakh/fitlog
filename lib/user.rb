class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :workouts

  validates_presence_of :name
end
