# Nettoyage de la base
puts "Suppression des anciennes données..."
Exclusion.destroy_all
Draw.destroy_all
User.destroy_all
Group.destroy_all

user_images_path = Rails.root.join('db', 'users')

# Reset primary key sequence for each table (PostgreSQL syntax)
ActiveRecord::Base.connection.reset_pk_sequence!("exclusions")
ActiveRecord::Base.connection.reset_pk_sequence!("users")
ActiveRecord::Base.connection.reset_pk_sequence!("groups")

# Création de groupes
puts "Création des groupes..."
group1 = Group.create!(name: "Famille Belgasmi larbi")
group2 = Group.create!(name: "Loto commun")
# group3 = Group.create!(name: "Famille test")

# Création d'utilisateurs (H/F) pour chaque groupe
puts "Ajout des utilisateurs..."

users_data = [
  { name: "Larbi Belgasmi", gender: "H", relation_type: 1, email: "larbi@belgasmi.com", password: "Larbi2025", group: group1, only_same_gender: true , image: 'larbi.jpeg'},
  { name: "Soraya Belgasmi", gender: "F", relation_type: 0, email: "soraya@belgasmi.com", password: "Soraya2025", group: group1, only_same_gender: true , image: 'soraya.jpeg'},
  { name: "Mohamed Belgasmi", gender: "H", relation_type: 0, email: "mohamed@belgasmi.com", password: "Mohamed2025", group: group1, only_same_gender: true , image: 'mohamed.jpeg'},
  { name: "Ilies Belgasmi", gender: "H", relation_type: 0, email: "ilies@belgasmi.com", password: "Ilies2025", group: group1, only_same_gender: true , image: 'ilies.jpeg'},
  { name: "imed Belgasmi", gender: "H", relation_type: 0, email: "imed@belgasmi.com", password: "Imed2025", group: group1, only_same_gender: true , image: 'imed.jpeg'},
  { name: "djessim Belgasmi", gender: "H", relation_type: 0, email: "djessim@belgasmi.com", password: "Djessim2025", group: group1, only_same_gender: true , image: 'djessim.jpeg'},
  { name: "Sarah Belgasmi", gender: "F", relation_type: 0, email: "sarah@belgasmi.com", password: "Sarah2025", group: group1, only_same_gender: true , image: 'sarah.jpeg'},
  { name: "Safa Belgasmi", gender: "F", relation_type: 0, email: "safa@belgasmi.com", password: "Safa2025", group: group1, only_same_gender: true , image: 'fatima.jpeg'},
  { name: "Maroy Belgasmi", gender: "F", relation_type: 1, email: "maroy@belgasmi.com", password: "Maroy2025", group: group1, only_same_gender: true , image: 'maroy.jpeg'},
  { name: "Fatima Belgasmi", gender: "F", relation_type: 1, email: "fatima@belgasmi.com", password: "Fatima2025", group: group1, only_same_gender: true , image: 'fatima.jpeg'},
  { name: "Amine Neghbel", gender: "H", relation_type: 1, email: "amine@neghbel.com", password: "123456", group: group1, only_same_gender: true , image: 'amine.jpeg'},


  # { name: "Amine", gender: "H", relation_type: 0, email: "amine@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},
  # { name: "Sarah", gender: "F", relation_type: 0, email: "sarah@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},
  # { name: "Fatima", gender: "F", relation_type: 0, email: "fatima@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},
  # { name: "illies", gender: "H", relation_type: 0, email: "illies@test.com", password: "123456", group: group2, only_same_gender: true, image: 'john.png'},

]

users_data.each do |user_data|
  user = User.create!(user_data.reject { |d| d == :image})
  image_path = user_images_path.join(user_data[:image])
  if File.exist?(image_path)
    user.avatar.attach(io: File.open(image_path), filename: user_data[:image])
  else
    puts "⚠️ Image not found: #{image_path}"
  end
end


puts "✅ Données de test créées avec succès !"
