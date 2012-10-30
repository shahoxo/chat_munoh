# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :munoh do
    name Forgery::Basic.text
    twitter_name Forgery::Basic.text
  end
end
