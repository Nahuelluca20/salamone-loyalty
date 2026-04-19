# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin = User.find_or_create_by!(email_address: "admin@example.com") do |u|
  u.password = "changeme123"
  u.role = :admin
end

User.find_or_create_by!(email_address: "customer@example.com") do |u|
  u.password = "changeme123"
  u.role = :customer
end

PointsConversionRule.find_or_create_by!(pesos_per_point: 100) do |r|
  r.active = true
  r.created_by = admin
end

product_names = [ "Mate Stanley", "Yerba Playadito", "Termo Lumilagro" ]
product_names.each_with_index do |name, i|
  Product.find_or_create_by!(name: name) do |p|
    p.description = "Producto de muestra #{i + 1}"
    p.price = (i + 1) * 1500
    p.active = true
    p.created_by = admin
  end
end

promo = Promotion.find_or_create_by!(name: "Bienvenida 2x1") do |p|
  p.points_for_redemption = 500
  p.active = true
  p.created_by = admin
end
promo.update!(description: "Combinación clásica para empezar a canjear tus puntos.") if promo.description.blank?
promo.products = Product.where(name: product_names.first(2))
