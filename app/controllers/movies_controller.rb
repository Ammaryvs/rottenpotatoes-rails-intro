class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings

    if params[:ratings]
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = params[:ratings]  # Save to session
    elsif session[:ratings]
      @ratings_to_show = session[:ratings].keys
    else
      @ratings_to_show = @all_ratings
    end

    if params[:sort]
      @sort_column = params[:sort]
      session[:sort] = params[:sort]  # Save to session
    elsif session[:sort]
      @sort_column = session[:sort]
    else
      @sort_column = 'title'
    end

    # Create hash for ratings to show checkboxes
    @ratings_to_show_hash = @ratings_to_show.map { |rating| [rating, 1] }.to_h

    # Retrieve filtered and sorted movies
    @movies = Movie.with_ratings(@ratings_to_show).order(@sort_column)

    # Set CSS classes for sorted column
    @title_header_class = @sort_column == 'title' ? 'hilite bg-warning' : ''
    @release_date_header_class = @sort_column == 'release_date' ? 'hilite bg-warning' : ''
  end
  
  def clear_session
    session.clear
    redirect_to movies_path
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
