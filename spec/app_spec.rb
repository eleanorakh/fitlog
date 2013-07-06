ENV['RACK_ENV'] = 'test'

require File.expand_path('./app.rb')

require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'database_cleaner'

describe 'fitlog' do
  before { DatabaseCleaner.start }
  after { DatabaseCleaner.clean }

  include Capybara::DSL

  def app
    Sinatra::Application
  end

  before do
    Capybara.app = app
  end

  describe 'users index' do
    context 'with no users' do
      it 'displays a message' do
        visit '/users'
        expect(names_from_html).to be_empty
        empty_text = Nokogiri::HTML(page.html).css('p').first.text.strip
        expect(empty_text).to eq 'No users.'
      end
    end

    context 'with users' do
      it 'displays the user names' do
        User.new(:name => 'Ron').save
        User.new(:name => 'Harry').save
        visit '/users'
        expect(names_from_html).to match_array ['Ron', 'Harry']
      end
    end
  end

  describe 'user show' do
    it 'displays the user' do
      ron = User.new(:name => 'Ron')
      ron.save
      visit "/users/#{ron.id}"
      expect(page).to have_content 'Ron'
    end
  end
end

def names_from_html
  Nokogiri::HTML(page.html).css('html body ul li').map do |list_item|
    list_item.text.strip
  end
end
