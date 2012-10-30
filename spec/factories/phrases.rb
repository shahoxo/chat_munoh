# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phrase do
    keyword Forgery::Basic.text
    reply Forgery::Basic.text
    munoh_id 1
  end
end
