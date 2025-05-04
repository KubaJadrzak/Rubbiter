Rubit.destroy_all
Like.destroy_all
Hashtag.destroy_all
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
User.destroy_all

user = []

20.times do |i|
  new_user = User.create!(
    email: "user#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password",
    username: "user#{i + 1}",
  )

  # Create a cart for each user
  new_user.create_cart!

  user << new_user
end

rubit1 = user[1].rubits.create!(content: "Finally figured out how to debug in #rails! Now I feel like a wizard 🧙‍♂️")
rubit2 = user[1].rubits.create!(content: "Can we just talk about how #JavaScript’s async/await made my life easier? #Blessed")
rubit3 = user[1].rubits.create!(content: "Just got into #machinelearning and I feel like I’m in over my head. Anyone else? 🤖")
rubit4 = user[1].rubits.create!(content: "I’ve been trying to use #Docker for 2 days now and I swear, it’s like taming a lion. 🦁")
rubit5 = user[1].rubits.create!(content: "It’s crazy how many #gems I’m discovering for #rails! The community really is amazing!")

# Rubits for user[2]
rubit6 = user[2].rubits.create!(content: "Can’t decide whether I should stick to #React or dive into #Vue. Both are so tempting. 🤔")
rubit7 = user[2].rubits.create!(content: "Finally got #GraphQL working after hours of struggle. Never been more proud of myself. 🙌")
rubit8 = user[2].rubits.create!(content: "The #Redux pattern is giving me a headache, but I’m determined to get it right. #FrontEndDev")
rubit9 = user[2].rubits.create!(content: "Trying to optimize my #NodeJS backend, but these bugs are driving me crazy! 🐞")
rubit10 = user[2].rubits.create!(content: "Is anyone else obsessed with #webpack? Or am I the only one? 😬")

# Rubits for user[3]
rubit11 = user[3].rubits.create!(content: "Just finished building my first app with #Django! That framework is smooth! 🚀")
rubit12 = user[3].rubits.create!(content: "Learning #Python is a game changer, it’s like the Swiss army knife of programming languages. 🛠️")
rubit13 = user[3].rubits.create!(content: "Getting into #AI has my brain in knots. But I think I’m finally starting to understand it. 🤯")
rubit14 = user[3].rubits.create!(content: "Spent the last 2 hours debugging code… then I realized I forgot a semicolon. Classic. 😩")
rubit15 = user[3].rubits.create!(content: "Just installed #TensorFlow. I feel like I’m about to change the world or break something important. 🤖")

# Rubits for user[4]
rubit16 = user[4].rubits.create!(content: "Why do I always seem to break things when I use #Webpack? It’s supposed to make my life easier, right?")
rubit17 = user[4].rubits.create!(content: "Spent an hour trying to figure out #Sass variables. Finally got it, but why is CSS this confusing? 😅")
rubit18 = user[4].rubits.create!(content: "Can we talk about how frustrating it is to work with #RESTAPIs? Like, why are they so inconsistent?")
rubit19 = user[4].rubits.create!(content: "Just spent a full day learning about #CI/CD pipelines. It’s all coming together. Next stop: DevOps! 🚀")
rubit20 = user[4].rubits.create!(content: "Found a bug in my code after 3 hours of staring at the screen. The bug? A missing comma. 🤦‍♂️")

# Rubits for user[5]
rubit21 = user[5].rubits.create!(content: "Spent way too much time making my app look pretty with #CSS. Who knew design could be so hard?")
rubit22 = user[5].rubits.create!(content: "Learning about #Kubernetes and it feels like I’m trying to solve a Rubik’s Cube while blindfolded. 🧩")
rubit23 = user[5].rubits.create!(content: "Trying out #TypeScript and so far, it feels like learning a new dialect of JavaScript. 😬")
rubit24 = user[5].rubits.create!(content: "Why do I always feel like I’m behind on new technology? #ImposterSyndrome")
rubit25 = user[5].rubits.create!(content: "Just got a #React app to finally deploy. It’s a miracle, but I’ll take it. 🎉")

# Create Rubits for user[6]
rubit26 = user[6].rubits.create!(content: "Just tried out #elixir and I’m amazed. Such a cool language!")
rubit27 = user[6].rubits.create!(content: "Learning #flutter for cross-platform mobile apps, but it’s so overwhelming!")
rubit28 = user[6].rubits.create!(content: "Why is #javascript so messy? But, I can’t quit it. 😅")
rubit29 = user[6].rubits.create!(content: "Started using #docker today... now I know why developers love it!")
rubit30 = user[6].rubits.create!(content: "Anyone else here obsessed with #tailwindcss? It’s such a time-saver.")

# Create Rubits for user[7]
rubit31 = user[7].rubits.create!(content: "Can’t believe how fast #go is. Started using it today and it’s amazing!")
rubit32 = user[7].rubits.create!(content: "I need to learn #devops, but where do I even start?")
rubit33 = user[7].rubits.create!(content: "Building my first #kubernetes deployment. Let’s hope it works!")
rubit34 = user[7].rubits.create!(content: "Why do #databases have to be so complex? SQL is a beast!")
rubit35 = user[7].rubits.create!(content: "Struggling with #git merge conflicts... send help!")

# Create Rubits for user[8]
rubit36 = user[8].rubits.create!(content: "Discovered #svelte today, and I’m already in love with it!")
rubit37 = user[8].rubits.create!(content: "Coding for hours without breaks, my back is telling me it’s time for a stretch.")
rubit38 = user[8].rubits.create!(content: "Started experimenting with #rust. Is it as good as people say?")
rubit39 = user[8].rubits.create!(content: "Does anyone else feel like #typescript is just a little too strict?")
rubit40 = user[8].rubits.create!(content: "Building a simple API with #fastapi and it’s incredibly easy. Where’s the catch?")

# Create Rubits for user[9]
rubit41 = user[9].rubits.create!(content: "I’m trying to learn #flutter, but this #dart syntax is so weird!")
rubit42 = user[9].rubits.create!(content: "Can’t stop using #nestjs for my nodejs apps. Best framework for #nodejs!")
rubit43 = user[9].rubits.create!(content: "Trying to optimize a #postgresql query, but I feel like I’m just making it worse.")
rubit44 = user[9].rubits.create!(content: "Is #aws as hard as people say? Just signed up for it.")
rubit45 = user[9].rubits.create!(content: "Is #graphql really better than REST? I’ve been reading about it all day.")

# Create Rubits for user[10]
rubit46 = user[10].rubits.create!(content: "Started learning #solidity today... blockchain dev here I come!")
rubit47 = user[10].rubits.create!(content: "Building a personal project with #nextjs, it’s so smooth!")
rubit48 = user[10].rubits.create!(content: "Has anyone here tried #nestjs? It’s like #expressjs but with more power!")
rubit49 = user[10].rubits.create!(content: "Trying out #tailwindcss for the first time... I think I’m falling in love!")
rubit50 = user[10].rubits.create!(content: "Spent all day setting up #ci_cd pipelines. Wish I knew how to automate the setup.")
# Create Rubits for user[11]
rubit51 = user[11].rubits.create!(content: "Started using #pyqt to build a GUI for my Python app. It's a bit tricky!")
rubit52 = user[11].rubits.create!(content: "Can't decide if I should learn #graphql or improve my REST skills first...")
rubit53 = user[11].rubits.create!(content: "Testing out #mongodb for a new app. I feel like I’m going down the #nosql rabbit hole.")
rubit54 = user[11].rubits.create!(content: "Finally getting the hang of #redux. Anyone else feel like it's overkill for small apps?")
rubit55 = user[11].rubits.create!(content: "Started using #storybook to document my React components. It’s a game-changer!")

# Create Rubits for user[12]
rubit56 = user[12].rubits.create!(content: "Exploring #deno after years of #nodejs. Honestly, the new runtime is refreshing.")
rubit57 = user[12].rubits.create!(content: "I think I’m finally starting to understand how #graphql queries work...")
rubit58 = user[12].rubits.create!(content: "Getting into #flutter but am still struggling with the Dart syntax.")
rubit59 = user[12].rubits.create!(content: "I feel like every #vuejs tutorial I watch leads me to a rabbit hole.")
rubit60 = user[12].rubits.create!(content: "Playing around with #tailwindcss but it’s making me rethink my entire approach to design.")

# Create Rubits for user[13]
rubit61 = user[13].rubits.create!(content: "Who else is obsessed with #firebase? It’s got everything you need for web and mobile.")
rubit62 = user[13].rubits.create!(content: "Looking into #cloudfunctions to scale my app. Hope it works!")
rubit63 = user[13].rubits.create!(content: "Started using #angular again. I think I forgot everything since I last touched it.")
rubit64 = user[13].rubits.create!(content: "Anyone else love using #docker to containerize apps? I can’t go back to the old way of doing things.")
rubit65 = user[13].rubits.create!(content: "Trying out #kotlin for Android development. It’s like Java but with less pain.")

# Create Rubits for user[14]
rubit66 = user[14].rubits.create!(content: "Started writing my first #go script. I’m impressed by how fast it runs.")
rubit67 = user[14].rubits.create!(content: "Why does #racket always look so weird to me? But I’m trying to learn it anyway.")
rubit68 = user[14].rubits.create!(content: "Experimenting with #rust. I love the memory safety features but the syntax throws me off.")
rubit69 = user[14].rubits.create!(content: "Why is #python so slow when you try to scale it? Still love it though.")
rubit70 = user[14].rubits.create!(content: "Anyone tried out #flutter_web? It’s neat, but I still can’t trust it for production apps.")

# Create Rubits for user[15]
rubit71 = user[15].rubits.create!(content: "Just deployed my first app with #vercel. That was so easy!")
rubit72 = user[15].rubits.create!(content: "Anyone using #strapi for headless CMS? It’s been a lifesaver for my React projects.")
rubit73 = user[15].rubits.create!(content: "I’m in love with #nextjs, but #reactjs still confuses me sometimes.")
rubit74 = user[15].rubits.create!(content: "Learning #swift for iOS development. I can already tell it’s going to be a wild ride.")
rubit75 = user[15].rubits.create!(content: "Exploring #graphql subscriptions. Can’t believe I never used them before!")
# Create Rubits for user[16]
rubit76 = user[16].rubits.create!(content: "Just started learning #elixir. Why does the syntax feel so clean?")
rubit77 = user[16].rubits.create!(content: "Trying to figure out how to use #graphql with #rails. Anyone got any good tutorials?")
rubit78 = user[16].rubits.create!(content: "Finally diving into #rust. The compiler is my new best friend... or worst enemy.")
rubit79 = user[16].rubits.create!(content: "Why does working with #postgreSQL feel like magic sometimes?")
rubit80 = user[16].rubits.create!(content: "Diving into #reactnative to build a mobile app. Wish me luck!")

# Create Rubits for user[17]
rubit81 = user[17].rubits.create!(content: "Started using #fastapi for a new Python project. It’s ridiculously fast.")
rubit82 = user[17].rubits.create!(content: "I’m still amazed by how good #tailwindcss is for rapidly building UIs.")
rubit83 = user[17].rubits.create!(content: "Learning #typescript this weekend. So far, I’m mostly confused.")
rubit84 = user[17].rubits.create!(content: "Trying to optimize my #nodejs app. Why does everything seem slow?")
rubit85 = user[17].rubits.create!(content: "Getting into #flutter. It's a bit rough but the potential is huge!")

# Create Rubits for user[18]
rubit86 = user[18].rubits.create!(content: "Exploring #solidity and smart contracts. Blockchain is a whole new world!")
rubit87 = user[18].rubits.create!(content: "My first #docker container works perfectly... I think? #DockerConfused")
rubit88 = user[18].rubits.create!(content: "Anyone using #vue3? It’s a massive improvement over the old version.")
rubit89 = user[18].rubits.create!(content: "Trying to improve my #ci_cd pipeline. Why does it keep failing on me?")
rubit90 = user[18].rubits.create!(content: "Finally tried #redis for caching today. Now I want to use it for everything.")

# Create Rubits for user[19]
rubit91 = user[19].rubits.create!(content: "Started using #firebase_auth for my project. It’s way easier than I expected.")
rubit92 = user[19].rubits.create!(content: "Is anyone else completely lost trying to get #react_hooks to work?")
rubit93 = user[19].rubits.create!(content: "Learning #golang. It’s definitely got a different vibe from #python.")
rubit94 = user[19].rubits.create!(content: "Looking into #kubectl commands for Kubernetes. It’s like learning a new language.")
rubit95 = user[19].rubits.create!(content: "Trying #nestjs for the first time. Why does everything feel so modular?")

# Create Rubits for user[20]
rubit96 = user[0].rubits.create!(content: "Finally building something serious with #rails5. The nostalgia is real!")
rubit97 = user[0].rubits.create!(content: "Spent the day debugging #flask. How do people deal with all the errors?")
rubit98 = user[0].rubits.create!(content: "Diving into #mongodb for the first time. The NoSQL life is crazy.")
rubit99 = user[0].rubits.create!(content: "Learning about the #eventloop in #nodejs. Still wrapping my head around it.")
rubit100 = user[0].rubits.create!(content: "Exploring #vuex for state management in #vuejs. Can’t decide if I love it or hate it.")

users = User.all.to_a
rubits = Rubit.all.to_a

rubits.each do |rubit|
  likers = users.sample(rand(0..10))

  likers.each do |user|
    rubit.likes.create!(user: user)
  end
end

Product.create!(
  title: "Rubitter T-shirt",
  content: "A comfy and stylish t-shirt featuring the iconic Rubitter logo. Perfect for showing off your Rubitter pride wherever you go.",
  price: 29.99,
)

Product.create!(
  title: "Rubitter Mug",
  content: "Start your day right with a Rubitter-themed mug. Ideal for sipping coffee or tea while coding.",
  price: 12.50,
)

Product.create!(
  title: "Rubitter Hoodie",
  content: "Stay warm and cozy with the Rubitter hoodie. A must-have for Rubitter enthusiasts during those late-night coding sessions.",
  price: 39.99,
)

Product.create!(
  title: "Rubitter Hat",
  content: "This stylish Rubitter beanie will keep your head warm while showing your love for Rubitter programming.",
  price: 15.00,
)

Product.create!(
  title: "Rubitter Stickers",
  content: "Decorate your laptop, water bottle, or anywhere with these high-quality Rubitter-themed stickers. Perfect for any Rubitter fan.",
  price: 3.99,
)

Product.create!(
  title: "Rubitter Keychain",
  content: "A durable Rubitter-themed keychain that makes it easy to carry your love for Rubitter everywhere you go.",
  price: 7.49,
)

Product.create!(
  title: "Rubitter Socks",
  content: "Comfortable and warm Rubitter socks to keep your feet cozy while you work on your next Rubitter project.",
  price: 9.99,
)

Product.create!(
  title: "Rubitter Poster",
  content: "Bring Rubitter to your walls with this sleek, modern poster. Ideal for any Rubitter developer's office or home.",
  price: 14.00,
)

Product.create!(
  title: "Rubitter Tote Bag",
  content: "Show off your Rubitter spirit with this eco-friendly, spacious tote bag. Perfect for carrying your laptop and other essentials.",
  price: 19.99,
)

Product.create!(
  title: "Rubitter Phone Case",
  content: "Protect your phone with a Rubitter-inspired case, designed to fit most modern smartphones while showing off your love for the language.",
  price: 16.49,
)

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

puts "Seed data created!"
