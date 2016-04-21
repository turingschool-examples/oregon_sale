class Home
  def promoted_products
    Category.find_by_name("Essentials").products.shuffle[0..2]
  end
end
