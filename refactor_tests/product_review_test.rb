require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'

class ProductReview < Test::Unit::TestCase
   
   def setup
     @selenium = Selenium::WebDriver.for(:firefox)
   end
  
   def teardown
     @selenium.quit
   end
  
   def test_add_new_review
     unique_comment = generate_unique_comment
     review_id = generate_new_product_review(unique_comment)
                                    
     review = @selenium.find_element(:id, review_id)
     
     name = review.find_element(:class, "comment-author-metainfo").find_element(:class, "url").text
     comment = review.find_element(:class, "comment-content").text

     assert_equal("test", name)
     assert_equal(unique_comment, comment)
     
     parsed_date = DateTime.parse(review.find_element(:class, "comment-author-metainfo").find_element(:class, "commentmetadata").text)
     assert_equal(Date.today.year, parsed_date.year)
     assert_equal(Date.today.month, parsed_date.month)
     assert_equal(Date.today.day, parsed_date.day)
   end
   
   def test_adding_a_duplicate_review
     unique_comment = generate_unique_comment
     sleep 2
     generate_new_product_review(unique_comment)
     sleep 2
     generate_new_product_review(unique_comment)
     
     error = @selenium.find_element(:id, "error-page").text
     assert_equal("Duplicate comment detected; it looks as though you\u2019ve already said that!", error)
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
   
   def select_desired_product_on_homepage
     click('.arrow_text a[href*="Attraction"].more-info')
   end
   
   def generate_new_product_review(review)
      navigate_to_homepage
      select_desired_product_on_homepage
      fill_out_comment_form(review)
      get_newly_created_review_id
   end
   
   def fill_out_comment_form(comment)
      type_text("test", "author", :id)
      type_text("nomail@test.com", "email", :id)
      type_text("https://www.tripadvisor.in", "url", :id)
      click("#ReviewTitle")
      find_element("comment", :id).clear
      type_text(comment, "comment", :id)
      click("submit", :id)
   end
   
   def navigate_to_homepage
    @selenium.get("https://www.tripadvisor.in")
   end
   
   def generate_unique_comment
      "This is a comment for attraction and is for #{Time.now.to_i}"
   end
   
   def get_newly_created_review_id
     @selenium.current_url.split("#").last
   end
end

=begin
Refactoring Tests

At the end of the refactoring session, we should not have any new tests;
the only goal is to improve the existing tests

A. DRY Principle :
                  . to reduce long-term maintenance costs by removing all unnecessary duplication.
                  .  Not only do we remove the duplicate code and duplicate test implementations,
                     but we also remove duplicate test goals(test cases ,suites)
                  .  Single Point Of Truth (SPOT) because it attempts to store every single piece of unique information in one place only.

                  Advantages:Modular tests,Reduced duplication=Effieient,
                  Disadvantage:Constant Refactoring,Programming Effieiently ,
                  
                  ToDo
                  1.Moving code into a setup and teardown (setup,background,teardown)
                  2.Removing duplication with methods
                  3.Removing external test goals
                  
                  ref:http://www.amazon.com/Refactoring-Patterns-Joshua-Kerievsky/dp/0321213351
                  
B.The Hermetic test pattern
                  opposite of the Spaghetti pattern;
                  each test should be completely independent and self-sufficient.
                  Any dependency on other tests or third-party services that cannot be controlled should be avoided at all costs
                  
                  Advantage:Resilience ,Clean Start,Modular ,Random Order ,Parallel
                  Disadvantage:upfront design ,Runtime increase (due to setup) ,resource usage
                  
                  ToDo
                  1.Removing test-on-test dependence ,see function- fill_out_comment_form(comment)
                  2.Using timestamps as test data (unique)
                  3.Creating generic DRY methods ,see def find_element(element, strategy=:css)
  
  C.Random Order Principle
                  
=end
