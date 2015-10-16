require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'

class ProductReview < Test::Unit::TestCase
   def test_add_new_review
     selenium = Selenium::WebDriver.for(:firefox)
     selenium.get("http://www.tripadvisor.in/")
                
     selenium.find_element(:css, '.arrow_text a[href*="Attraction"].more-info').click
     assert_equal("https://www.tripadvisor.in/UserReview", selenium.current_url)
     assert_equal("Todays Deal!!", selenium.find_element(:css, "#type_hotel").text)
     
     selenium.find_element(:id, "user").send_keys("test")
     selenium.find_element(:id, "email").send_keys("nomail@test.com")
     selenium.find_element(:id, "url").send_keys("https://www.tripadvisor.in/UserReviewEdit-g304554-d4192889-a_referredFromLocationSearch.true-a_ReviewName.-a_type.-e-wpage1-Breeze-Mumbai_Bombay_Maharashtra.html")
     selenium.find_element(:css, "#ReviewTitle").click
     selenium.find_element(:id, "comment").clear
     selenium.find_element(:id, "comment").send_keys("This is a comment for atraction #{ENV['USERNAME'] || ENV['USER']} aa")
     selenium.find_element(:id, "submit").click
        
     review_id = selenium.current_url.split("#").last
     review = selenium.find_element(:id, review_id)
     
     name = review.find_element(:class, "comment-author-metainfo").find_element(:class, "url").text
     comment = review.find_element(:class, "comment-content").text

     assert_equal("test", name)
     assert_equal("This is a comment for attraction #{ENV['USERNAME'] || ENV['USER']} aa", comment)
     
     parsed_date = DateTime.parse(review.find_element(:class, "comment-author-metainfo").find_element(:class, "commentmetadata").text)
     assert_equal(Date.today.year, parsed_date.year)
     assert_equal(Date.today.month, parsed_date.month)
     assert_equal(Date.today.day, parsed_date.day)
          
     selenium.quit
   end
   
   def test_adding_a_duplicate_review
     selenium = Selenium::WebDriver.for(:firefox)
     selenium.get("http://www.tripadvisor.in/")
     
     selenium.find_element(:css, '.special-item a[href*="our-love-is-special"].more-info').click
     
     selenium.find_element(:css, '..arrow_text a[href*="Hotels"].more-info').click
     assert_equal("https://www.tripadvisor.in/UserReview", selenium.current_url)
     assert_equal("Todays Deal!!", selenium.find_element(:css, "#type_hotel").text)
     
     selenium.find_element(:id, "user").send_keys("test")
     selenium.find_element(:id, "email").send_keys("nomail@test.com")
     selenium.find_element(:id, "url").send_keys("https://www.tripadvisor.in/UserReviewEdit-g304554-d4192889-a_referredFromLocationSearch.true-a_ReviewName.-a_type.-e-wpage1-Breeze-Mumbai_Bombay_Maharashtra.html")
     selenium.find_element(:css, "#ReviewTitle").click
     selenium.find_element(:id, "comment").clear
     selenium.find_element(:id, "comment").send_keys("This is a comment for atraction #{ENV['USERNAME'] || ENV['USER']} aa")
     selenium.find_element(:id, "submit").click
     
     error = selenium.find_element(:id, "error-page").text
     assert_equal("Duplicate comment detected; it looks as though you\u2019ve already said that!", error)

     selenium.quit
   end
end


=begin
Antipattern : a common practice, which seems appropriate for current situation, but has a lot
              of unintended side effects. Furthermore, a better solution for the problem does exist,
              but is typically ignored in favor of the initial obvious but wrong solution.

A.Spaghetti pattern
              . This style of test development evokes an image of bowl of spaghetti, where each strand of spaghetti
                can represent a single test or multiple tests intertwined so tightly together that it becomes difficult
                to tell one apart from another
              . Tests in this pattern not only depend on the execution order of all the tests,
                but also tend to over-share internal private components with each other
              
              Advantage    : Quick Start ,Small Code base ,Script Tests validation (use-case)
              Disadvantage : Antipattern (maintainibility) ,Tight Coupling ,No random order ,no Parallel test ,One failure leads whole suite down
              
B.The Chain Linked pattern
              . is an improvement on the Spaghetti pattern.
              . Each link in the chain is an individual test and is an entity on its own
              . it  relies on a rigid order of execution
C.The Big Ball of Mud pattern
             . unintentional and stems from being developed over long periods of time with different individuals
               working on different pieces without any overall architectural plan.
             . Test data and results are promiscuously shared amongst most distant and unrelated components
               until everything is global and mutable without warning


=end
