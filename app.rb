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

  get '/albums' do
    repo = AlbumRepository.new
    albums = repo.all

    response = albums.map do |album|
      album.title
    end.join(', ')

    return response
  end

  get '/albums/1' do
    repo = AlbumRepository.new
    albums = repo.find(1)

    return albums.title
  end

  post '/albums' do
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    return repo.create(new_album)
  end

  # patch '/albums/1' do
  #   repo = AlbumRepository.new
  #   album = repo.update(1)
  #   album.title = params[:title]
  #   album.release_year = params[:release_year]
  #   album.artist_id = params[:artist_id]

  #   return ''
  # end

  delete '/albums/1' do
    repo = AlbumRepository.new
    album = repo.delete(1)

    return ''
  end

  get '/artists' do
    repo = ArtistRepository.new
    albums = repo.all

    list = albums.map do |artist|
      artist.name
    end.join(', ')

    return list
  end

  post '/artists' do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    
    return repo.create(new_artist)
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
