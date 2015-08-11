class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = MoviesController.ratings    
    @movies = Movie.all
    if params[:sort_by_title] then      
      @movies.sort! {|a,b| a.title <=> b.title}
    elsif params[:sort_by_date] then      
      @movies.sort! {|a,b| a.release_date <=> b.release_date}
    elsif params[:ratings] then
      @movies = MoviesController.filter_by_ratings(params[:ratings])
    else
      @movies = Movie.all
    end
  end

  def self.filter_by_ratings(rate)    
    result = Array.new 
    rate.each_key do |key|
      result.push(key)
    end
    return Movie.where({rating:result})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def self.ratings
    return Movie.uniq.pluck(:rating)
  end
end
