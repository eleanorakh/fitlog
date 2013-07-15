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

      it 'allows navigation to the show page' do
        ron = User.new(:name => 'Ron')
        ron.save
        visit '/users'
        expect(names_from_html).to match_array ['Ron']
        click_link 'Ron'
        expect(current_path).to eq "/users/#{ron.id}"
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

  describe 'workouts index' do
    it 'displays workouts for the user' do
      harry = User.new(:name => 'Harry')
      harry.save
      Workout.new(:user_id => harry.id, :exercise_type => 'Running').save
      ron = User.new(:name => 'Ron')
      ron.save
      Workout.new(:user_id => ron.id, :exercise_type => 'Swimming')
      visit "/users/#{harry.id}/workouts"
      expect(page).to have_content 'Running'
      expect(page).to have_no_content 'Swimming'
    end
  end
end

def names_from_html
  Nokogiri::HTML(page.html).css('html body ul li').map do |list_item|
    list_item.text.strip
  end
end
