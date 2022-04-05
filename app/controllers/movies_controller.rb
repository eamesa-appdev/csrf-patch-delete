class MoviesController < ApplicationController
  def new
    @the_movie = Movie.new
  end

  def index
    matching_movies = Movie.all

    @list_of_movies = matching_movies.order({ :created_at => :desc })

    respond_to do |format|
      format.json do
        render json: @list_of_movies
      end

      format.html do
        render({ :template => "movies/index.html.erb" })
      end
    end
  end

  def show
    the_id = params.fetch(:id)

    #matching_movies = Movie.where({ :id => the_id })

    #@the_movie = matching_movies[0]

    @the_movie = Movie.find(the_id)

    if @the_movie == nil
      raise "There is no movie with that id"
    end

    render({ :template => "movies/show.html.erb" })
  end

  def create
    @the_movie = Movie.new
    @the_movie.title = params.fetch("query_title")
    @the_movie.description = params.fetch("query_description")

    if @the_movie.valid?
      @the_movie.save
      redirect_to("/movies", { :notice => "Movie created successfully." })
    else
      render "new"
    end
  end

#find_by(:column => value)   it is the same as .where(:column => value).first
#Can return a record or a nil if no record matches

  def update
    #the_id = params.fetch(:id)
    #the_movie = Movie.where({ :id => the_id })[0]
    the_movie = Movie.find(params.fetch(:id))

    the_movie.title = params.fetch("query_title")
    the_movie.description = params.fetch("query_description")

    if the_movie.valid?
      the_movie.save
      redirect_to("/movies/#{the_movie.id}", { :notice => "Movie updated successfully."} )
    else
      redirect_to("/movies/#{the_movie.id}", { :alert => "Movie failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch(:id)
    the_movie = Movie.where({ :id => the_id })[0]

    the_movie.destroy

    redirect_to("/movies", { :notice => "Movie deleted successfully."} )
  end
end
