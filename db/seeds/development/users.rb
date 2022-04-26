10.times do |n|
  name = "user#{n}"
  email = "#{name}@example.com"
  user = User.find_or_initialize_by(email: email, activated: true)

  if user.new_record?
    user.name = name
    user.password = "password"
    user.phone_number="#{n}11-1111-1111"
    user.post_code="#{n}11-1111"
    user.address="seed"
    user.save!
  end
end

puts "users = #{User.count}"
