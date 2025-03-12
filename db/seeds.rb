# Nettoyage de la base
puts "Suppression des anciennes données..."
AcceptedUser.destroy_all
Draw.destroy_all
User.destroy_all
Group.destroy_all

user_images_path = Rails.root.join('db', 'users')

# Reset primary key sequence for each table (PostgreSQL syntax)
ActiveRecord::Base.connection.reset_pk_sequence!("accepted_users")
ActiveRecord::Base.connection.reset_pk_sequence!("users")
ActiveRecord::Base.connection.reset_pk_sequence!("groups")

# Création de groupes
puts "Création des groupes..."
group1 = Group.create!(name: "Famille Belgasmi larbi")
group2 = Group.create!(name: "Famille Neghbel Amine")
group3 = Group.create!(name: "Famille test")

# Création d'utilisateurs (H/F) pour chaque groupe
puts "Ajout des utilisateurs..."

users_data = [
  { name: "Larbi Belgasmi", gender: "H", relation_type: 1, email: "larbi@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Soraya Belgasmi", gender: "F", relation_type: 0, email: "soraya@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Mohamed Belgasmi", gender: "H", relation_type: 0, email: "mohamed@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Illies Belgasmi", gender: "H", relation_type: 0, email: "illies@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "imed Belgasmi", gender: "H", relation_type: 0, email: "imed@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "djessim Belgasmi", gender: "H", relation_type: 0, email: "djessim@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Sarah Belgasmi", gender: "F", relation_type: 0, email: "sarah@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Safaa Belgasmi", gender: "F", relation_type: 0, email: "safaa@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Maroy Belgasmi", gender: "F", relation_type: 1, email: "maroy@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Fatima Belgasmi", gender: "F", relation_type: 1, email: "fatima@belgasmi.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},
  { name: "Amine Neghbel", gender: "H", relation_type: 1, email: "amine@neghbel.com", password: "123456", group: group1, only_same_gender: true , image: 'john.png'},


  { name: "Amine", gender: "H", relation_type: 0, email: "amine@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},
  { name: "Sarah", gender: "F", relation_type: 0, email: "sarah@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},
  { name: "Fatima", gender: "F", relation_type: 0, email: "fatima@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},
  { name: "illies", gender: "H", relation_type: 0, email: "illies@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},

]

users_data.each do |user_data|
  user = User.create!(user_data.reject { |d| d == :image})
  # image_path = user_images_path.join(user_data[:image])
  # if File.exist?(image_path)
  #   user.avatar.attach(io: File.open(image_path), filename: user_data[:image])
  # else
  #   puts "⚠️ Image not found: #{image_path}"
  # end
end

# Retrieve specific users from group3
amine = User.find_by(email: "amine@test.com")
sarah = User.find_by(email: "sarah@test.com")
fatima = User.find_by(email: "fatima@test.com")
illies = User.find_by(email: "illies@test.com")

# Define specific accepted user relationships
accepted_users_data = [
  { user: amine, accepted_users: [sarah] },
  { user: sarah, accepted_users: [amine, illies] },
  { user: fatima, accepted_users: [illies] },
  { user: illies, accepted_users: [sarah, fatima] }
]

# Create AcceptedUser records
accepted_users_data.each do |entry|
  user = entry[:user]
  entry[:accepted_users].each do |accepted_user|
    AcceptedUser.create!(user: user, accepted_user: accepted_user)
  end
end

puts "✅ Specific AcceptedUsers relationships created successfully!"


puts "✅ Données de test créées avec succès !"
