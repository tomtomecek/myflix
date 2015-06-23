tom = User.create(email: "tom@example.com", password: "password", fullname: "Tom Tom", admin: true)
Fabricate.times(4, :user)

tv_shows = Category.create!(name: "TV shows")
movies = Category.create!(name: "Movies")

["Interstellar", "V for Vendetta", "Inception", "District 9", "Family guy", "Monk", 
  "South Park", "Futurama"].each_with_index do |title, index|
  video = Fabricate.build(:video,
    title: title,
    category: (index < 4 ? movies : tv_shows),
    video_url: "https://s3.amazonaws.com/tt-myflix/Interstellar+Movie+-+Official+Trailer+3.mp4")
  video.small_cover.store!(File.open(File.join(Rails.root, "public/tmp/interstellar.jpg")))
  video.large_cover.store!(File.open(File.join(Rails.root, "public/tmp/interstellar_large.jpg")))
  video.save!

  5.times { Fabricate(:review, video: video, user: User.all.sample) }
end

4.times { Fabricate(:relationship, follower: tom) }