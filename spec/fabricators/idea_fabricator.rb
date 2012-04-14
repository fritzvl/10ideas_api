Fabricator(:idea) do
   essential {Faker::Lorem.sentence(15)}
   public { %w(true false).sample}
   created_at { Time.now - 1.day}
end