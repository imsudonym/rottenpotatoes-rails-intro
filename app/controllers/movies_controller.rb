class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected = session[:selected]
    get_movies_by_rating

    @sort_by = params[:sort_by] || session[:sort_by]

    if @sort_by == 'title'
      @sort_title = session[:sort_title] || true
      @sort_release_date = false
      @movies = @movies.sort_by &:title
    elsif @sort_by == 'date'
      @sort_title = false
      @sort_release_date = session[:sort_release_date] || true
      @movies = @movies.sort_by &:release_date
    else
      @sort_title = session[:sort_title] || false
      @sort_release_date = session[:sort_release_date] || false
    end

    session[:sort_by] = @sort_by
    session[:sort_title] = @sort_title
    session[:sort_release_date] = @sort_release_date
  end

  def get_movies_by_rating
    @all_ratings = Movie.ratings
    ratings = params[:ratings] || session[:selected]
    if ratings != nil
      @selected = []
      ratings.each do |k, v|
        if @movies == nil
          @movies = Movie.where(rating: k)
        else
          @movies = @movies + Movie.where(rating: k)
        end
        @selected << k
      end
    else
      @movies = Movie.all
    end

    session[:selected] = @selected
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
