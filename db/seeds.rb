# Nettoyage de la base
puts "Suppression des anciennes données..."
Draw.destroy_all
User.destroy_all
Group.destroy_all

# Création de groupes
puts "Création des groupes..."
group1 = Group.create!(name: "Famille Belgasmi larbi")
group2 = Group.create!(name: "Famille Neghbel Amine")

# Création d'utilisateurs (H/F) pour chaque groupe
puts "Ajout des utilisateurs..."

users_data = [
  { name: "Larbi Belgasmi", gender: "H", relation_type: 1, email: "larbi@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Soraya Belgasmi", gender: "F", relation_type: 0, email: "soraya@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Mohamed Belgasmi", gender: "H", relation_type: 0, email: "mohamed@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Illies Belgasmi", gender: "H", relation_type: 0, email: "illies@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "imed Belgasmi", gender: "H", relation_type: 0, email: "imed@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "djessim Belgasmi", gender: "H", relation_type: 0, email: "djessim@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Sarah Belgasmi", gender: "F", relation_type: 0, email: "sarah@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Safaa Belgasmi", gender: "F", relation_type: 0, email: "safaa@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Maroy Belgasmi", gender: "F", relation_type: 1, email: "maroy@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Fatima Belgasmi", gender: "F", relation_type: 1, email: "fatima@belgasmi.com", password: "123456", group: group1, only_same_gender: true },
  { name: "Amine Neghbel", gender: "H", relation_type: 1, email: "amine@neghbel.com", password: "123456", group: group1, only_same_gender: true },

  { name: "Mehdi Neghbel", gender: "H", relation_type: 0, email: "mehdi@neghbel.com", password: "123456", group: group2, only_same_gender: true },
  { name: "Akram Neghbel", gender: "H", relation_type: 0, email: "akram@neghbel.com", password: "123456", group: group2, only_same_gender: true },
  { name: "Fares Neghbel", gender: "H", relation_type: 0, email: "fares@neghbel.com", password: "123456", group: group2, only_same_gender: true },
  { name: "Adel Neghbel", gender: "H", relation_type: 0, email: "adel@neghbel.com", password: "123456", group: group2, only_same_gender: true },
]

users_data.each do |user_data|
  User.create!(user_data)
end

puts "✅ Données de test créées avec succès !"
