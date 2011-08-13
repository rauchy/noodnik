# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nag do
      id 1
      next_nag "2011-08-13 07:24:47"
      completed false
    end
end