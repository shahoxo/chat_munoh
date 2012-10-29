# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phrase do
    keyword "MyString"
    reply "MyText"
  end
end
