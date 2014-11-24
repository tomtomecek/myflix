User.create(email: "tom@example.com", password: "password", fullname: "Tom Tom")
25.times do |n|
  fullname = Faker::Lorem.name
  User.create(
    fullname: fullname, 
    password: "password", 
    email: "#{fullname.gsub(' ', '.')}-#{n}@example.com")
end

tv_shows = Category.create(name: "TV shows")
movies = Category.create(name: "Movies")

["Interstellar", "V for Vendetta", "Inception", "District 9", 
  "Family guy", "Monk", "South Park", "Futurama"].each_with_index do |title, index|
  video = Video.create(
    category: (index < 4 ? movies : tv_shows),
    title: title,
    description: Faker::Lorem.words(Array(20..30).sample).join(" "),
    small_cover_url: "/tmp/#{title.gsub(' ', '_').downcase}.jpg",
    large_cover_url: "/tmp/#{title.gsub(' ', '_').downcase}_large.jpg")

  Array(15..30).sample.times do
    video.reviews.create(
      body: Faker::Lorem.words(Array(15..20).sample).join(" "), 
      rating: Array(1..5).sample,
      user: User.all.sample)
  end
end