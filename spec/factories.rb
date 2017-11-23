FactoryBot.define do
  factory :user do
    username "tanhuynh"
    email "test@abc.com"
    first_name "Tan"
    last_name "Huynh"
    password "password"
    password_confirmation "password"

    after :create, &:confirm
  end

  factory :category do
    name "Cat a"
    parent nil
  end

  factory :tour do
    name "Tour a"
    departure "Location A"
    arrival "Location B"
    overview "Overview"
    itinerary "Itinerary"
    category
    after :build do |tour|
      tour.pictures << FactoryBot.build(:picture, tour: tour, is_thumbnail: true)
    end
  end

  factory :picture do
    is_thumbnail false
    image{File.new(Rails.root.join(Rails.root, "spec", "support", "fixtures", "images", "thumbnail.jpg"))}
    tour
  end
end
