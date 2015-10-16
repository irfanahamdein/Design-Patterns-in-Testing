require 'rubygems'
require 'selenium-webdriver'

Given(/^I am on the home page$/) do
  @selenium = Selenium::WebDriver.for(:firefox)
  @selenium.get "https://www.tripadvisor.in"
end

Given(/^I add first special offers item to the cart$/) do
  page = HomePage.new(@selenium)
  page.special_items.first.add_to_cart
end

Given(/^I navigate to Contact Us Page$/) do
  @selenium.get "https://www.tripadvisor.in/UserReview"
end

Then(/^the shopping cart should have correct information$/) do
  page = ContactUsPage.new(@selenium)
  expect(page.sidebar.cart.summary).to eq("You have 1 comment in your places.")
  expect(page.sidebar.cart.subtotal).to eq("wow")
  @selenium.quit
end
