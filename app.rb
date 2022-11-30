# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  set :logging, true

  # get '/' do
  #   # The erb method takes the view file name (as a Ruby symbol)
  #   # and reads its content so it can be sent 
  #   # in the response.
  #   # @name - params[:name]
  #   # @names = ['Anna', 'Kim', 'Josh', 'David']
  #   # @password = params[:password]

  #   # @cohort_name = 'May 2022'
  #   return erb(:index)
  # end

  # get '/about' do
  #   return erb(:about)
  # end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    # response = @albums.map do |album|
    #   album.title
    # end.join(', ')

    return erb(:album_list)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_repo = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end

  # get '/albums/1' do
  #   repo = AlbumRepository.new
  #   albums = repo.find(1)

  #   return albums.title
  # end

  post '/albums' do
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return ''
  end

  # patch '/albums/1' do
  #   repo = AlbumRepository.new
  #   new_album = Album.new
  #   new_album.title = params[:title]
  #   new_album.release_year = params[:release_year]
  #   new_album.artist_id = params[:artist_id]

  #   repo.create(new_album)
  #   last2 = repo.all[-2, -1]

  #   return last2
    
  # end

  delete '/albums/1' do
    repo = AlbumRepository.new
    album = repo.delete(1)

    return ''
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    # list = albums.map do |artist|
    #   artist.name
    # end.join(', ')

    return erb(:artist_list)
  end

  post '/artists' do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    
    return repo.create(new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new

    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  # get '/albums/:id' do
  #   album_id = params[:id]
  
  #   # Use album_id to retrieve the corresponding
  #   # album from the database.
  # end
  
  # delete '/albums/:id' do
  #   album_id = params[:id]
  
  #   # Use album_id to delete the corresponding
  #   # album from the database.
  # end
end
