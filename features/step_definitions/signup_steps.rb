When /^I confirm my email$/ do
  get "/users/#{@user.id}/confirmation/new?salt=#{@user.salt}"
end

When /^I go to the forgot password page$/ do
  get "/passwords/new"
end

Then /^a new user with the email "(.*)" should be created$/ do |email|
  @user = User.find_by_email(email)
  assert_not_nil @user
end

Then /^the signup form should be shown again$/ do
  assert_template "users/new"  
end

Then /^I should\s?((?:not)?) be registered$/ do |present|
  assert_nil User.find_by_email("francine@yoyoma.com")
end

Then /^an email with the subject "(.*)" should be sent to me$/ do |subject|
  assert_sent_email do |email|
    @user.blank? || email.to.include?(me.email)
    email.subject =~ /#{subject}/i
  end
end
