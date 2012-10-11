# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    provider "twitter"
    uid Forgery::Basic.text
    name Forgery::Basic.text
  end
end
