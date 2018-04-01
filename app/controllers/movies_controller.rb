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
    if session[:sort_title] == true
      sort_title
      redirect_to "/movies/sort_title"
    elsif session[:sort_release_date] == true
      sort_release_date
      redirect_to "/movies/sort_release_date"
    else
      @all_ratings = Movie.ratings
      @selected = ["G", "R", "PG", "PG-13"]
      if params[:ratings] != nil
        @selected = []
        ratings = params[:ratings]
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
    end
  end

  def sort_title
    session[:sort_title] = true
    session[:sort_release_date] = false

    @all_ratings = Movie.ratings
    @selected = ["G", "R", "PG", "PG-13"]
    if params[:ratings] != nil
      @selected = []
      ratings = params[:ratings]
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
    @movies = @movies.order('title')
  end

  def sort_release_date
    session[:sort_release_date] = true
    session[:sort_title] = false

    @all_ratings = Movie.ratings
    @selected = ["G", "R", "PG", "PG-13"]
    if params[:ratings] != nil
      @selected = []
      ratings = params[:ratings]
      ratings.each do |k, v|
        if   @movies == nil
          @movies = Movie.where(rating: k)
        else
          @movies = @movies + Movie.where(rating: k)
        end
        @selected << k
      end
    else
      @movies = Movie.all
    end
    @movies = @movies.order('release_date')
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
