class AdminController < ApplicationController

	#before_filter :authorise

	def index
		list
		render :action => 'list'
	end

	def list
		@products = Products.find(:all).paginate :per_page => 10, :page => params[:page]
	end

	def show
		@product = Product.find(params[:id])
	end

	def new
		@product = Product.new
	end

	def create
		@product = Product.new(params[:product])
		if @product.save
			@product.tag(params[:tags])
			flash[:notice] = 'Product was successfully created.'
			redirect_to :action => 'list'
		else
			render :action => 'new'
		end
	end

	def edit
		@product = Product.find(params[:id])
	end

	def update
		@product = Product.find(params[:id])
		if @product.update_attributes(params[:product])
			flash[:notice] = 'Product was successfully updated.'
			redirect_to :action => 'show', :id => @product
		else
			render :action => 'edit'
		end
	end

	def destroy
		Product.find(params[:id]).destroy
		redirect_to :action => 'list'
	end

end
