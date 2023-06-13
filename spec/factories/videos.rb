FactoryBot.define do
  factory :video do
    url { "https://www.youtube.com/watch?v=#{Faker::Alphanumeric.alpha(number: 10)}" }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    thumbnail_url { Faker::Internet.url }
    association :sharer, factory: :user
  end
end