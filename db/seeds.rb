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
  { name: "Mohamed Belgasmi", gender: "H", relation_type: 0, email: "mohamed@belgasmi.com", password: "Mohamed2025", only_same_gender: true, image: 'mohamed.jpeg', groups: [group1, group2] },
  { name: "Ilies Belgasmi", gender: "H", relation_type: 0, email: "ilies@belgasmi.com", password: "Ilies2025", only_same_gender: true, image: 'ilies.jpeg', groups: [group1] },
  { name: "Imed Belgasmi", gender: "H", relation_type: 0, email: "imed@belgasmi.com", password: "Imed2025", only_same_gender: true, image: 'imed.jpeg', groups: [group1] },
  { name: "Djessim Belgasmi", gender: "H", relation_type: 0, email: "djessim@belgasmi.com", password: "Djessim2025", only_same_gender: true, image: 'djessim.jpeg', groups: [group1] },
  { name: "Sarah Belgasmi", gender: "F", relation_type: 0, email: "sarah@belgasmi.com", password: "Sarah2025", only_same_gender: true, image: 'sarah.jpeg', groups: [group1, group2] },
  { name: "Safa Belgasmi", gender: "F", relation_type: 0, email: "safa@belgasmi.com", password: "Safa2025", only_same_gender: true, image: 'safa.jpeg', groups: [group1, group2] },
  { name: "Maroy Belgasmi", gender: "F", relation_type: 1, email: "maroy@belgasmi.com", password: "Maroy2025", only_same_gender: true, image: 'maroy.jpeg', groups: [group1, group2] },
  { name: "Fatima Belgasmi", gender: "F", relation_type: 1, email: "fatima@belgasmi.com", password: "Fatima2025", only_same_gender: true, image: 'fatima.jpeg', groups: [group1] },
  { name: "Amine Neghbel", gender: "H", relation_type: 1, email: "amine@neghbel.com", password: "123456", only_same_gender: true, image: 'amine.jpeg', groups: [group1, group2] }, # Appartient aux 2 groupes

  ## Loto commun
  { name: "Adam Belgasmi", gender: "H", relation_type: 1, email: "adam@belgasmi.com", password: "Adam2025", only_same_gender: true, image: 'adam.jpeg', groups: [group2] }, # Appartient aux 2 groupes
  { name: "Redha Belgasmi", gender: "H", relation_type: 1, email: "redha@belgasmi.com", password: "Redha2025", only_same_gender: true, image: 'redha.jpeg', groups: [group2] },
  { name: "Idriss Belgasmi", gender: "H", relation_type: 1, email: "idriss@belgasmi.com", password: "Idriss2025", only_same_gender: true, image: 'idriss.jpeg', groups: [group2] },
  { name: "Amine Mohamadi", gender: "H", relation_type: 1, email: "amine@mohamadi.com", password: "Amine2025", only_same_gender: true, image: 'amine_mohamadi.jpeg', groups: [group2] },
  { name: "Mehdi Mohamadi", gender: "H", relation_type: 1, email: "mehdi@mohamadi.com", password: "Mehdi2025", only_same_gender: true, image: 'mehdi_mohamadi.jpeg', groups: [group2] },
  { name: "Messaoud Mohamadi", gender: "H", relation_type: 1, email: "messaoud@mohamadi.com", password: "Messaoud2025", only_same_gender: true, image: 'messaoud.jpeg', groups: [group2] },
  { name: "Dylan Dahan", gender: "H", relation_type: 1, email: "dylan@dahan.com", password: "Dylan2025", only_same_gender: true, image: 'dylan.jpeg', groups: [group2] },
  { name: "Nadji Alem", gender: "H", relation_type: 1, email: "nadji@alem.com", password: "Nadji2025", only_same_gender: true, image: 'nadji.jpeg', groups: [group2] },
  { name: "Fares Alem", gender: "H", relation_type: 1, email: "fares@alem.com", password: "Fares2025", only_same_gender: true, image: 'fares.jpeg', groups: [group2] },
  { name: "Zineb Belgasmi", gender: "F", relation_type: 1, email: "zineb@belgasmi.com", password: "Zineb2025", only_same_gender: true, image: 'zineb.jpeg', groups: [group2] },
  { name: "Ahlem Belgasmi", gender: "F", relation_type: 1, email: "ahlem@belgasmi.com", password: "Ahlem2025", only_same_gender: true, image: 'ahlem.jpeg', groups: [group2] },
  { name: "Hayet Belgasmi", gender: "F", relation_type: 1, email: "hayet@belgasmi.com", password: "Hayet2025", only_same_gender: true, image: 'hayet.jpeg', groups: [group2] },
  { name: "Saliha Belgasmi", gender: "F", relation_type: 1, email: "saliha@belgasmi.com", password: "Saliha2025", only_same_gender: true, image: 'saliha.jpeg', groups: [group2] },
  { name: "Nabila Belgasmi", gender: "F", relation_type: 1, email: "nabila@belgasmi.com", password: "Nabila2025", only_same_gender: true, image: 'nabila.jpeg', groups: [group2] },
  { name: "Ines Belgasmi", gender: "F", relation_type: 1, email: "ines@belgasmi.com", password: "Ines2025", only_same_gender: true, image: 'ines.jpeg', groups: [group2] },
  { name: "Myriam Belgasmi", gender: "F", relation_type: 1, email: "myriam@belgasmi.com", password: "Myriam2025", only_same_gender: true, image: 'myriam.jpeg', groups: [group2] },
  { name: "Kiyane Belgasmi", gender: "F", relation_type: 1, email: "kiyane@belgasmi.com", password: "Kiyane2025", only_same_gender: true, image: 'kiyane.jpeg', groups: [group2] },
  { name: "Minane Belgasmi", gender: "F", relation_type: 1, email: "minane@belgasmi.com", password: "Minane2025", only_same_gender: true, image: 'minane.jpeg', groups: [group2] },
  { name: "Wafa Alem", gender: "F", relation_type: 1, email: "wafa@alem.com", password: "Wafa2025", only_same_gender: true, image: 'wafa.jpeg', groups: [group2] },
  { name: "Norhane Alem", gender: "F", relation_type: 1, email: "norhane@alem.com", password: "Norhane2025", only_same_gender: true, image: 'norhane.jpeg', groups: [group2] },
  { name: "Amel Belgasmi", gender: "F", relation_type: 1, email: "amel@belgasmi.com", password: "Amel2025", only_same_gender: true, image: 'amel.jpeg', groups: [group2] },
  { name: "Lina Soualmi", gender: "F", relation_type: 1, email: "lina@soualmi.com", password: "Lina2025", only_same_gender: true, image: 'lina.jpeg', groups: [group2] },
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
