require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
  end

  before(:each) do 
    reset_artists_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

    # Albums resource:
  context 'GET to /albums' do
    # List all the albums
      it 'list all the albums' do
        response = get('/albums')

        expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'
        expect(response.status).to eq(200)
        expect(response.body).to eq(expected_response)
      end
  end

  #   # Read a single album
  #   Request: GET /albums/1
  #   Response: of a single album
  context 'GET to /albums/1' do
    it 'reads a single album' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Doolittle')
    end
  end

  #   # Create a new album
  #   Request: POST /albums
  #     With body parameters: "title=OK Computer"
  #   Response: None (just creates the resource on the server)
  context 'POST to /albums' do
    it 'creates a new album' do
      response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('OK Computer')
    end
  end

  #   # Update a single album - there's no update method
  #   Request: PATCH /albums/1
  #     With body parameters: "title=OK Computer"
  #   Response: None (just updates the resource on the server)
  # context 'PATCH to /albums/1' do
  #   xit 'update a single album' do
  #     response = get('/albums/1')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('Doolittle')

  #     response = patch('/albums/1', title: 'OK Computer', release_year: '1997', artist_id: '1')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('')

  #     response = get('/albums/1')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('OK Computer')

  #   end
  # end

  #   # Delete an album
  #   Request: DELETE /albums/1
  #   Response: None (just deletes the resource on the server)

  context 'DELETE to /albums/1' do
    it 'delete an album' do
      response = delete('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).not_to include('Doolittle')
    end
  end

  #artists
  context 'GET to /artists' do
    # List all the albums
      it 'list all the artists' do
        response = get('/artists')

        expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'
        expect(response.status).to eq(200)
        expect(response.body).to eq(expected_response)
      end
  end

  context 'POST to /artists' do
    it 'creates a new artist in the database' do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('Wild nothing')
    end
  end
end
