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
    context 'with no users' do
      it 'displays a message' do
        get '/users'
        expect(last_response).to be_ok
        expect(names_from_html).to be_empty
        empty_text = Nokogiri::HTML(last_response.body).css('p').first.text.strip
        expect(empty_text).to eq 'No users.'
      end
    end

    context 'with users' do
      it 'displays the user names' do
        User.new(:name => 'Ron').save
        User.new(:name => 'Harry').save
        get '/users'
        expect(last_response).to be_ok
        expect(names_from_html).to match_array ['Ron', 'Harry']
      end
    end
  end
end

def names_from_html
  Nokogiri::HTML(last_response.body).css('html body ul li').map do |list_item|
    list_item.text.strip
  end
end
