FactoryBot.define do
  factory :user do
    email  { Faker::Internet.unique.email }
    password { 'youtube@123' }
    password_confirmation { 'youtube@123' }
  end
end