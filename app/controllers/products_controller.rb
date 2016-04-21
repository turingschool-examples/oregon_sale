class ProductsController < ApplicationController
  before_filter :set_product, only: [:show, :retire]
  before_filter :check_retired_product, only: [:show]

  def check_retired_product
    redirect_to home_show_path if @product.retired?
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def show
  end

  def index

    @dashboard = Dashboard.new
    authorize! :manage, Product

    render :index
  end

  def list
    @products = Product.order("name").active
    @categories = Category.all
  end

  def retire
    authorize! :update, @product
    @product.update_attribute("retired", true)
    redirect_to admin_path
  end

  def unretire
    product = Product.find(params[:id])
    authorize! :update, product
    product.retired = false
    product.save

    redirect_to admin_path
  end



  def new
    @product = Product.new
    authorize! :create, @product

    render :new
  end

  def edit
    @product = Product.find(params[:id])
    authorize! :update, @product

    @categories = Category.all
  end

  def create
    @product = Product.new(params[:product])
    authorize! :create, @product

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    end
  end

  def update
    @product = Product.find(params[:id])
    authorize! :update, @product

    params[:product][:retired] ||= []
    params[:product][:category_ids] ||= []
    @product = Product.find(params[:id])

    if @product.update_attributes(params[:product])
      redirect_to @product, notice: 'Product was successfully updated.'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    authorize! :destroy, @product
    @product.destroy

    redirect_to products_url
  end
end
