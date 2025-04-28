user = []

20.times do
  new_user = FactoryBot.create(:user)
  user << new_user

  5.times do
    FactoryBot.create(:rubit, user: new_user)
  end
end

users = User.all.to_a
rubits = Rubit.all.to_a

rubits.each do |rubit|
  likers = users.sample(rand(0..10))

  likers.each do |user|
    FactoryBot.create(:like, user: user, rubit: rubit)
  end
end

FactoryBot.create(:product, title: "Rubitter T-shirt", content: "A comfy and stylish t-shirt featuring the iconic Rubitter logo. Perfect for showing off your Rubitter pride wherever you go.", price: 29.99)
FactoryBot.create(:product, title: "Rubitter Mug", content: "Start your day right with a Rubitter-themed mug. Ideal for sipping coffee or tea while coding.", price: 12.50)
FactoryBot.create(:product, title: "Rubitter Hoodie", content: "Stay warm and cozy with the Rubitter hoodie. A must-have for Rubitter enthusiasts during those late-night coding sessions.", price: 39.99)
FactoryBot.create(:product, title: "Rubitter Hat", content: "This stylish Rubitter beanie will keep your head warm while showing your love for Rubitter programming.", price: 15.00)
FactoryBot.create(:product, title: "Rubitter Stickers", content: "Decorate your laptop, water bottle, or anywhere with these high-quality Rubitter-themed stickers. Perfect for any Rubitter fan.", price: 3.99)
FactoryBot.create(:product, title: "Rubitter Keychain", content: "A durable Rubitter-themed keychain that makes it easy to carry your love for Rubitter everywhere you go.", price: 7.49)
FactoryBot.create(:product, title: "Rubitter Socks", content: "Comfortable and warm Rubitter socks to keep your feet cozy while you work on your next Rubitter project.", price: 9.99)
FactoryBot.create(:product, title: "Rubitter Poster", content: "Bring Rubitter to your walls with this sleek, modern poster. Ideal for any Rubitter developer's office or home.", price: 14.00)
FactoryBot.create(:product, title: "Rubitter Tote Bag", content: "Show off your Rubitter spirit with this eco-friendly, spacious tote bag. Perfect for carrying your laptop and other essentials.", price: 19.99)
FactoryBot.create(:product, title: "Rubitter Phone Case", content: "Protect your phone with a Rubitter-inspired case, designed to fit most modern smartphones while showing off your love for the language.", price: 16.49)

first_user = User.first

products = Product.limit(3)

products.each do |product|
  FactoryBot.create(
    :cart_item,
    cart: first_user.cart,
    product: product,
    quantity: rand(1..3),
    price: product.price,
  )
end
