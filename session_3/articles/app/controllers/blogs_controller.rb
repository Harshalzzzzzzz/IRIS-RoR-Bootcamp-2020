class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)
      if @blog.save
        redirect_to root_path, flash[:notice] = 'Created blog #{@blog.title}' 
      else
        flash[:error] = 'Error' 
      end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    if @blog.update(blog_params)
      redirect_to root_path, flash[:notice] = 'Updated #{@blog.title}' 
    else
      flash[:error] = 'Not Updated ' 
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog = Blog.find(params[:id])
    if @blog.delete   
      redirect_to root_path, flash[:notice] = 'Deleted!'      
    else   
      flash[:error] = 'Failed to delete!'   
    end     
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :article)
    end
end
