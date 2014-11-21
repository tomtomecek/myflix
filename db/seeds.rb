# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Video.create(title: "Interstellar", 
             description: "A team of explorers travel through a wormhole in an attempt to find a potentially habitable planet that will sustain humanity.", 
             small_cover_url: "/public/tmp/interstellar.jpg", 
             large_cover_url: "/public/tmp/interstellar_large.jpg")
Video.create(title: "V for Vendetta", 
             description: "n a future British tyranny, a shadowy freedom fighter plots to overthrow it with the help of a young woman.", 
             small_cover_url: "/public/tmp/v_for_vendetta.jpg", 
             large_cover_url: "/public/tmp/v_for_vendetta_large.jpg")
Video.create(title: "Inception", 
             description: "A thief who steals corporate secrets through use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.", 
             small_cover_url: "/public/tmp/inception.jpg", 
             large_cover_url: "/public/tmp/inception_large.jpg")
Video.create(title: "District 9", 
             description: "An extraterrestrial race forced to live in slum-like conditions on Earth suddenly finds a kindred spirit in a government agent who is exposed to their biotechnology.", 
             small_cover_url: "/public/tmp/district9.jpg", 
             large_cover_url: "/public/tmp/district9_large.jpg")