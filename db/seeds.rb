tom = User.create(email: "tom@example.com", password: "password", fullname: "Tom Tom", admin: true)
Fabricate.times(10, :user)

tv_shows = Category.create(name: "TV shows")
movies = Category.create(name: "Movies")

["Interstellar", "V for Vendetta", "Inception", "District 9", 
  "Family guy", "Monk", "South Park", "Futurama"].each_with_index do |title, index|
  video = Fabricate(:video,
    category: (index < 4 ? movies : tv_shows),
    title: title,
    small_cover_url: "/tmp/#{title.gsub(' ', '_').downcase}.jpg",
    large_cover_url: "/tmp/#{title.gsub(' ', '_').downcase}_large.jpg")

  15.times { Fabricate(:review, video: video, user: User.all.sample) }
end

10.times { Fabricate(:relationship, follower: tom) }
