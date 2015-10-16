require 'rubygems'
require 'selenium-webdriver'

Given(/^I am on the home page$/) do
  @selenium = Selenium::WebDriver.for(:firefox)
  @selenium.get "https://www.tripadvisor.in"
end

When (/^I Add a Review to Page$/) do
  page = ReviewPage.new(@selenium)
  page.reviews.add_review
end

Given(/^I navigate to Review Page$/) do
  @selenium.get "https://www.tripadvisor.in/UserReview"
end


Then(/^the shopping cart should have correct information$/) do
  expect(page.sidebar.cart.summary).to eq("You have 1 comment in your places.")
  expect(page.sidebar.cart.subtotal).to eq("wow")
  @selenium.quit
end
