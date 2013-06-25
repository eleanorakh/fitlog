ENV['RACK_ENV'] = 'test'

require File.expand_path('./app.rb')

require 'rspec'
require 'rack/test'
require 'database_cleaner'

describe 'fitlog' do
  before { DatabaseCleaner.start }
  after { DatabaseCleaner.clean }

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'users index' do
    context 'with users' do
      it 'displays the user names' do
        User.new(:name => 'Ron').save
        User.new(:name => 'Harry').save
        get '/users'
        expect(last_response).to be_ok
        names = Nokogiri::HTML(last_response.body).css('html body ul li').map do |list_item|
          list_item.text.strip
        end
        expect(names).to match_array ['Ron', 'Harry']
      end
    end
  end
end
