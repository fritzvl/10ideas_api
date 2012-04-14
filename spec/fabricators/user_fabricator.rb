Fabricator(:user) do
  email {Faker::Internet.email}
  password {Faker::Internet.ip_v6_address}
  ideas(:count=>10) { |parent, i| Fabricate(:idea, :user_id => parent.id) }
end