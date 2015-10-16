require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require File.join(File.dirname(__FILE__), 'test_data')


class PlacesReview < Test::Unit::TestCase
   
   def setup
     @places_permalink = TestData.get_places_fixtures["fixture_4"]["url"]
     @selenium = Selenium::WebDriver.for(:firefox)
   end
  
   def teardown
     @selenium.quit
   end
  
   def test_add_new_review
     review_form_info = TestData.get_comment_form_values({:name => "Dima"})
     review_id = generate_new_places_review(review_form_info)
                                    
     review = @selenium.find_element(:id, review_id)
     
     name = review.find_element(:class, "comment-author-metainfo").find_element(:class, "url").text
     comment = review.find_element(:class, "comment-content").text

     assert_equal("test", name)
     assert_equal(review_form_info[:comment], comment)
     
     parsed_date = DateTime.parse(review.find_element(:class, "comment-author-metainfo").find_element(:class, "commentmetadata").text)
     assert_equal(Date.today.year, parsed_date.year)
     assert_equal(Date.today.month, parsed_date.month)
     assert_equal(Date.today.day, parsed_date.day)
   end
   
   def test_adding_a_duplicate_review
     review_form_info = TestData.get_comment_form_values
     generate_new_place_review(review_form_info)
     sleep 2
     generate_new_place_review(review_form_info)
     error = @selenium.find_element(:id, "error-page").text
     assert_equal("Duplicate comment detected", error)
   end

   private
   
   def find_element(element, strategy=:css)
     @selenium.find_element(strategy, element)
   end
   
   def type_text(text, element, strategy=:css)
      find_element(element, strategy).send_keys(text)
   end
   
   def click(element, strategy=:css)
      find_element(element, strategy).click
   end
   
   def select_desired_place_on_homepage(permalink)
     click(".arrow_text a[href*='#{permalink}'].more-info")
   end
   
   def generate_new_place_review(review)
      navigate_to_homepage
      select_desired_places_on_homepage(@places_permalink)
      fill_out_comment_form(review)
      get_newly_created_review_id
   end
   
   def fill_out_comment_form(form_info)
      type_text(form_info[:name], "test", :id)
      type_text(form_info[:email], "email", :id)
      type_text(form_info[:url], "url", :id)
      click("#ReviewTitle")
      find_element("comment", :id).clear
      type_text(form_info[:comment], "comment", :id)
      click("submit", :id)
   end
   
   def navigate_to_homepage
    @selenium.get(TestData.get_base_url)
   end
   
   def generate_unique_comment
      "This is a comment for attraction and is for #{Time.now.to_i}"
   endi
   
   def get_newly_created_review_id
     @selenium.current_url.split("#").last
   end
end


=begin
Data Driven Tests:
                  test data is the complete state of the whole environment we are testing
                  methods :Fixtures,Stubs,YAML,JSON,API Endpoints,Seed ,Default ,Faker
                  
                  1.Hiding test data from tests
                    a single place that stores data and provides it to the test on request.
                    For this, we will create a new class called TestData in the test_data.rb
                  
                  2.seperate the run time config (test environment,drivers ,suite)
                  3.For dynamic data ,use API (session token ,attraction info)
                  4.Stubs :Stubs are premade responses to our application's requests
                           use case (3PL ,Payments ,any 3rd Party lol..)
                    
=end
