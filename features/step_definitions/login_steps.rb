Given /^a registered user with the email "(.*)" with password "(.*)" exists$/ do |email, password|
  @user = Factory(:registered_user, :email => email, :password => password, :password_confirmation => password)
end

Given /^a confirmed user with the email "(.*)" with password "(.*)" exists$/ do |email, password|
  @user = Factory(:email_confirmed_user, :email => email, :password => password, :password_confirmation => password)
end

Given /^no current user$/ do
  logout_user
end

Then /^the login form should be shown$/ do
  assert_template "sessions/new"
end

Then /^I should\s?((?:not)?) be authorized$/ do |present|
  assert_response present ? :unauthorized : :success
end

Then /^I should\s?((?:not)?) be signed in$/ do |present|
  assert_equal(controller.signed_in?, present.blank?) if controller
end