class ProductsController < ApplicationController
  
  #auto_complete_for :product, :name
  
  def index
    @valid_products = Product.find_products_for_sale
		@products = @valid_products.paginate :per_page => 5, :page => params[:page]
  end

  def new 
  end

  def create
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
