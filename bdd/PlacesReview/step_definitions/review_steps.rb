When(/^I create a new unique review$/) do
  @form_values = TestData.get_comment_form_values
  @form_values[:comment] << " #{Time.now.to_i}"
  @comment_id = create_a_comment(@form_values)
end

Then(/^my name should be attached to the comment$/) do
  assert_equal(@form_values[:name], @selenium.get_inner_text("#" + @comment_id + " .comment-author-metainfo a.url"))
end

Then(/^my comment should be properly saved$/) do
  assert_equal(@form_values[:comment], @selenium.get_inner_text("#" + @comment_id + " .comment-content"))
end

Then(/^the comment date should be correct date$/) do
  date    = @selenium.get_inner_text("#" + @comment_id + " .comment-author-metainfo .commentmetadata")
  parsed_date = DateTime.parse(date)
  assert_equal(Date.today.year, parsed_date.year)
  assert_equal(Date.today.month, parsed_date.month)
  # assert_equal(Date.today.day, parsed_date.day)
end

When(/^I try to add an identical review again$/) do
  create_a_comment(@form_values)
end

Then(/^I should see a duplicate comment error$/) do
  assert(@selenium.get_inner_text("body").include?("Duplicate comment detected"))
end


def create_a_comment(form_info)
   fill_out_comment_form(form_info)
   sleep 10
   @selenium.current_url.split("#").last
end

def fill_out_comment_form(form_info)
   @selenium.type_text(form_info[:name], "test", :id)
   @selenium.type_text(form_info[:email], "email", :id)
   @selenium.type_text(form_info[:website], "url", :id)
   @selenium.click("#ReviewTitle")
   @selenium.type_text(form_info[:comment], "comment", :id)
   @selenium.click("submit", :id)
end



=begin
Behaviour Driven Tests:
                       Behavior-driven Development (BDD) encourages us to step back and think of how the application should behave end-to-end first,
                       and only then concentrate on the smaller details.

Advantage :Data seperation ,live document ,modular Implementation
Disavantage:Added overhead of Behaviour ,Easy to mix behavior and implementation ,Example Skill


Examples Best Practices
1.Flexible pluralization

Let's imagine that we need to write a step that contains a singular or plural noun depending on its count:
When the user has 1 gift
...
When the user has 5 gifts
...
Instead of implementing two similar step definitions, we can adopt a tip in Cucumber called Flexible Pluralization; the step to match the preceding steps is as follows:
When /^the user has (\d+) gifts?$/ do |num|
 p num.to_i
end

2.Non-capturing groups
Sometimes the plural of a noun is irregular, such as person/people, knife/knives. We cannot match them through flexible pluralization, and for these scenarios we need to adopt non-capturing groups, because Cucumber's step statements are eventually treated as regular expressions:
When there is 1 person in the meeting room
When there are 8 people in the meeting room
We can define our step as follows:

When /^there (?:is|are) (\d+) (?:person|people) in the meeting room$/ do |num|
 p num.to_i
end

By adding a ?: before a normal group, the step will try to match one occurrence of the given word and will not pass the matched value into arguments. Non-capturing groups ensure Gherkin's good readability when dealing with singulars and plurals, and in a DRY manner since one generic step matches various kinds of styles.

end


continue...
                       
=end
