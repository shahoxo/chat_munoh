# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :talk do
    log Forgery::Basic.text
    user_id 1
    room_id 1
  end
end
