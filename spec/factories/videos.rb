FactoryBot.define do
  factory :video do
    url { Faker::Internet.url(host: 'youtube') }
    sharer { create(:user) }
    description { Faker::Movie.quote }
    title { Faker::Movie.title }
    thumbnail_url { Faker::Internet.url(host: 'youtube') }
  end
end