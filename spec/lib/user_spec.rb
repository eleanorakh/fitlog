ENV['RACK_ENV'] = 'test'

require File.expand_path('./lib/user.rb')

require 'rspec'

describe User do
  describe 'validations' do
    it 'validates presence of name' do
      user = User.new
      expect(user.valid?).to be_false
      expect(user.errors[:name]).to eq ['Name must not be blank']
      user.name = 'Hagrid'
      expect(user.valid?).to be_true
    end
  end
end
