# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "TV shows")
Category.create(name: "Movies")

Video.create(category: Category.find_by(name: "Movies"),
             title: "Interstellar", 
             description: "A team of explorers travel through a wormhole in an attempt to find a potentially habitable planet that will sustain humanity.", 
             small_cover_url: "/tmp/interstellar.jpg", 
             large_cover_url: "/tmp/interstellar_large.jpg")
Video.create(category: Category.find_by(name: "Movies"),
             title: "V for Vendetta", 
             description: "n a future British tyranny, a shadowy freedom fighter plots to overthrow it with the help of a young woman.", 
             small_cover_url: "/tmp/v_for_vendetta.jpg", 
             large_cover_url: "/tmp/v_for_vendetta_large.jpg")
Video.create(category: Category.find_by(name: "Movies"),
             title: "Inception", 
             description: "A thief who steals corporate secrets through use of dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.", 
             small_cover_url: "/tmp/inception.jpg", 
             large_cover_url: "/tmp/inception_large.jpg")
Video.create(category: Category.find_by(name: "Movies"),
             title: "District 9",
             description: "An extraterrestrial race forced to live in slum-like conditions on Earth suddenly finds a kindred spirit in a government agent who is exposed to their biotechnology.", 
             small_cover_url: "/tmp/district9.jpg", 
             large_cover_url: "/tmp/district9_large.jpg")
Video.create(category: Category.find_by(name: "TV shows"),
             title: "Family guy", 
             description: "In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.", 
             small_cover_url: "/tmp/family_guy.jpg", 
             large_cover_url: "/tmp/family_guy_large.jpg")
Video.create(category: Category.find_by(name: "TV shows"),
             title: "Monk", 
             description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.", 
             small_cover_url: "/tmp/monk.jpg", 
             large_cover_url: "/tmp/monk_large.jpg")
Video.create(category: Category.find_by(name: "TV shows"),
             title: "South Park",
             description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.", 
             small_cover_url: "/tmp/south_park.jpg", 
             large_cover_url: "/tmp/south_park_large.jpg")
Video.create(category: Category.find_by(name: "TV shows"),
             title: "Futurama", 
             description: "Fry, a pizza guy is accidentally frozen in 1999 and thawed out New Year's Eve 2999.", 
             small_cover_url: "/tmp/futurama.jpg", 
             large_cover_url: "/tmp/futurama_large.jpg")


User.create(email: "tom@example.com", password: "123", fullname: "Tom Hannon")
User.create(email: "alice@example.com", password: "123", fullname: "Alice Wonderland")
User.create(email: "phil@example.com", password: "123", fullname: "Philip J. Fry")
