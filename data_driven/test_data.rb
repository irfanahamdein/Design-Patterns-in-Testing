require 'yaml'
require 'net/http'
require 'json'
require 'faker'

class TestData
  
  def self.get_full_name
    Faker::Name.name
  end
  
  def self.get_email
    Faker::Internet.email
  end
  
  def self.get_website
    Faker::Internet.url
  end
  
  def self.get_comment
    Faker::Company.catch_phrase
  end
  
  def self.get_comment_form_values(overwrites = {})
    {
      :name    => self.get_full_name,
      :email   => self.get_email,
      :url     => self.get_website,
      :comment => self.get_comment
    }.merge(overwrites)
  end
  
     
  def self.get_places_fixtures
    fixture_file = File.join(File.dirname(__FILE__), 'places_fixtures.yml')
    YAML.load_file(fixture_file)
  end
  
  def self.get_places_from_api
    uri = URI.parse("http://api.tripadvisor.in")
    json_string = Net::HTTP.get(uri)
    JSON.parse(json_string)
  end
  
  def self.get_environment
     ENV['environment'] || "test"
  end
  
  def self.get_base_url
    {
      "production" => "https://www.tripadvisor.in/",
      "release"    => "http://staging.tripadvisor.in/",
      "test"       => "http://test.tripadvisor.in/"
    }[self.get_environment]
  end
  
end
