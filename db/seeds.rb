# Nettoyage de la base
puts "Suppression des anciennes données..."
Exclusion.destroy_all
Draw.destroy_all
GroupMembership.destroy_all
User.destroy_all
Group.destroy_all

user_images_path = Rails.root.join('db', 'users')

# Reset primary key sequence for PostgreSQL
%w[exclusions draws group_memberships users groups].each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

# Création des groupes
puts "Création des groupes..."
group1 = Group.create!(name: "Famille Belgasmi Larbi")
group2 = Group.create!(name: "Loto Commun")

# Création des utilisateurs et de leurs groupes
puts "Ajout des utilisateurs..."

users_data = [
  { name: "Larbi Belgasmi", gender: "H", relation_type: 1, email: "larbi@belgasmi.com", password: "Larbi2025", only_same_gender: true, image: 'larbi.jpeg', groups: [group1] },
  { name: "Soraya Belgasmi", gender: "F", relation_type: 0, email: "soraya@belgasmi.com", password: "Soraya2025", only_same_gender: true, image: 'soraya.jpeg', groups: [group1, group2] },
  { name: "Mohamed Belgasmi", gender: "H", relation_type: 0, email: "mohamed@belgasmi.com", password: "Mohamed2025", only_same_gender: true, image: 'mohamed.jpeg', groups: [group1] },
  { name: "Ilies Belgasmi", gender: "H", relation_type: 0, email: "ilies@belgasmi.com", password: "Ilies2025", only_same_gender: true, image: 'ilies.jpeg', groups: [group1] },
  { name: "Imed Belgasmi", gender: "H", relation_type: 0, email: "imed@belgasmi.com", password: "Imed2025", only_same_gender: true, image: 'imed.jpeg', groups: [group1] },
  { name: "Djessim Belgasmi", gender: "H", relation_type: 0, email: "djessim@belgasmi.com", password: "Djessim2025", only_same_gender: true, image: 'djessim.jpeg', groups: [group1] },
  { name: "Sarah Belgasmi", gender: "F", relation_type: 0, email: "sarah@belgasmi.com", password: "Sarah2025", only_same_gender: true, image: 'sarah.jpeg', groups: [group1, group2] },
  { name: "Safa Belgasmi", gender: "F", relation_type: 0, email: "safa@belgasmi.com", password: "Safa2025", only_same_gender: true, image: 'safa.jpeg', groups: [group1, group2] },
  { name: "Maroy Belgasmi", gender: "F", relation_type: 1, email: "maroy@belgasmi.com", password: "Maroy2025", only_same_gender: true, image: 'maroy.jpeg', groups: [group1, group2] },
  { name: "Fatima Belgasmi", gender: "F", relation_type: 1, email: "fatima@belgasmi.com", password: "Fatima2025", only_same_gender: true, image: 'fatima.jpeg', groups: [group1] },
  { name: "Amine Neghbel", gender: "H", relation_type: 1, email: "amine@neghbel.com", password: "123456", only_same_gender: true, image: 'amine.jpeg', groups: [group1, group2] }, # Appartient aux 2 groupes
]

users_data.each do |user_data|
  groups = user_data.delete(:groups) # Retirer les groupes du hash avant la création
  user = User.create!(user_data.except(:image)) # Créer l'utilisateur

  # Associer l'utilisateur aux groupes
  groups.each { |group| GroupMembership.create!(user: user, group: group) }

  # Assigner l'avatar
  image_path = user_images_path.join(user_data[:image])
  if File.exist?(image_path)
    user.avatar.attach(io: File.open(image_path), filename: user_data[:image])
  else
    puts "⚠️ Image introuvable : #{image_path}"
  end
end

puts "✅ Données de test créées avec succès !"
