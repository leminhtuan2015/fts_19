User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "12345678",
             admin:     true)

9.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  User.create!(name: name,
              email: email,
              password: "password",
              admin:     false)
  Subject.create!(name: name, description: email)
end

