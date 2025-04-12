# db/seeds.rb

# Create Users
user1 = User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password', username: 'user1')
user2 = User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password', username: 'user2')
user3 = User.create!(email: 'user3@example.com', password: 'password', password_confirmation: 'password', username: 'user3')

# Create Rubits for user1
rubit1 = user1.rubits.create!(content: "This is my first rubit with #ruby and #rails")
rubit2 = user1.rubits.create!(content: "Loving the #rails framework, so #productive!")
rubit3 = user1.rubits.create!(content: "Exploring new gems! #rails #rubyonrails")

# Create Rubits for user2
rubit4 = user2.rubits.create!(content: "Building cool apps with #reactjs")
rubit5 = user2.rubits.create!(content: "I prefer #vuejs over #reactjs")
rubit6 = user2.rubits.create!(content: "Learning about #graphQL today")

# Create Rubits for user3
rubit7 = user3.rubits.create!(content: "Trying out #machinelearning and #AI")
rubit8 = user3.rubits.create!(content: "My first #python script is working!")
rubit9 = user3.rubits.create!(content: "Let's build something amazing with #django")

# Add Likes for Rubits
rubit1.likes.create!(user: user2)
rubit1.likes.create!(user: user3)
rubit2.likes.create!(user: user1)
rubit3.likes.create!(user: user2)
rubit4.likes.create!(user: user3)
rubit5.likes.create!(user: user1)
rubit6.likes.create!(user: user2)
rubit7.likes.create!(user: user1)
rubit8.likes.create!(user: user3)
rubit9.likes.create!(user: user2)

# Add Favorites for Rubits
user1.favorites.create!(rubit: rubit1)
user2.favorites.create!(rubit: rubit4)
user3.favorites.create!(rubit: rubit7)

puts "Seed data created!"