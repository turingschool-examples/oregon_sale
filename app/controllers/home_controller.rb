class HomeController < ApplicationController
  def show
    @categories = Category.all.sort
    @products = Home.new.promoted_products
  end
end
