# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :room do
    title Forgery::Basic.text
    user_id 1
    munoh_id 1
  end
end
