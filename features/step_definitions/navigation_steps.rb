Given /^I am on the "(.*)" page$/ do |url|
  get url
end

When /^I access a page$/ do
  get "/"
end