# db/seeds.rb

require "faker"

puts "🔄 Nettoyage de la base..."
Exclusion.destroy_all
Draw.destroy_all
GroupMembership.destroy_all
User.destroy_all
Group.destroy_all

# Reset primary key sequence (PostgreSQL)
%w[exclusions draws group_memberships users groups].each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

puts "🎯 Création des groupes..."
groups = [
  Group.create!(name: "Famille Belgasmi"),
  Group.create!(name: "Loto Commun"),
  Group.create!(name: "Collègues de bureau"),
  Group.create!(name: "Amis proches")
]

puts "👤 Création des utilisateurs..."

# Chemin pour les images d'avatars
user_images_path = Rails.root.join('db', 'users')
avatar_files = Dir.entries(user_images_path).select { |f| f =~ /\.(jpg|jpeg|png)$/i }

users = []

20.times do |i|
  gender = ["H", "F"].sample
  username = Faker::Name.first_name + " " + Faker::Name.last_name
  user = User.new(
    username: username,
    gender: gender,
    relation_type: [0, 1].sample,
    password: "123456",
    only_same_gender: [true, false].sample
  )

  # Attacher un avatar aléatoire
  avatar_file = avatar_files.sample
  if avatar_file
    user.avatar.attach(io: File.open(user_images_path.join(avatar_file)), filename: avatar_file)
  end

  # Sauvegarde
  user.save!
  users << user
end

puts "✅ #{users.count} utilisateurs créés."

puts "➕ Attribution des utilisateurs aux groupes..."
users.each do |user|
  groups.sample(rand(1..2)).each do |group|
    group.users << user unless group.users.include?(user)
  end
end

groups.each do |group|
  puts "📌 Groupe '#{group.name}' a #{group.users.count} participants."
end

puts "⚠️ Création d'exclusions aléatoires..."
users.each do |user|
  other_users = users - [user]
  excluded = other_users.sample(rand(0..3))
  excluded.each do |ex_user|
    Exclusion.create!(user: user, excluded_user: ex_user)
  end
end

puts "🎲 Création de tirages pour certains groupes..."
groups.each do |group|
  next if group.users.count < 2 # Au moins 2 participants pour un tirage

  if [true, false].sample
    shuffled = group.users.shuffle
    shuffled.each_with_index do |u, idx|
      recipient = shuffled[(idx + 1) % shuffled.size]
      Draw.create!(user: u, recipient: recipient, group: group)
    end
    puts "✅ Tirage créé pour le groupe '#{group.name}'"
  else
    puts "⏳ Pas encore de tirage pour le groupe '#{group.name}'"
  end
end

puts "🎉 Seed terminé !"
