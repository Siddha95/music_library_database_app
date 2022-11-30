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

  # context "GET to /" do
  #   it 'contains a h1 title' do
  #     response = get('/')
  
  #     expect(response.body).to include('<h1>hello</h1>')
      
  #     # <img src ="hello.jpg" />
  #     expect(response.body).to include('<img src="hello.jpg')
  #   end

  #   it 'returns an html message with a name' do
  #     response = get('/', name: 'Leo')

  #     expect(response.body).to include('<h1=Hell Leo!>h1')
  #   end

  #   it 'return an html messahe with a different name' do
  #     response = get('/', name: 'Clara')

  #     expect(response.body).to include('<h1=Hell Clara!>h1')
  #   end

  #   it 'returns an html list of names' do
  #     response = get('/')

  #     expect(response.body).to include('<p>Anna<p>')
  #     expect(response.body).to include('<p>Kim<p>')
  #     expect(response.body).to include('<p>Josh<p>') 
  #     expect(response.body).to include('<p>David<p>')
  #   end

  #   it 'returns a hello page if the password is correct' do
  #     response = get('/', password: 'abcd')

  #     expec(response.body).to include('Hello')
  #   end
    
  #   it 'returns a forbidden page if the password is incorrect' do
  #     response = get('/', password: 'efgh')

  #     expec(response.body).to include('Access forbidden')
  #   end
  #   it 'contains a div' do
  #     response = get('/')
  
  #     expect(response.body).to include('<div>')
  #   end
  # end

  context 'GET /albums/:id' do
    it 'should return info about album 1' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

   
  context 'GET to /albums' do
    # List all the albums
      it 'list all the albums' do
        response = get('/albums')

        expect(response.status).to eq(200)
        expect(response.body).to include('Doolittle 1989')
        expect(response.body).to include('Surfer Rosa 1988')
      end

      # it 'contains a div' do
      #   response = get('/albums')
  
      #   expect(response.body).to include('<div>')
    # end
  end

  context 'GET to /albums' do
    # List all the albums
      it 'list all the albums on another web page' do
        response = get('/albums')

        expect(response.status).to eq(200)
        expect(response.body).to match('<a href="/albums/1">Doolittle.*</a><br />')
        expect(response.body).to match('<a href="/albums/2">Surfer Rosa.*</a><br />')
        expect(response.body).to match('<a href="/albums/3">Waterloo.*</a><br />')
        expect(response.body).to match('<a href="/albums/4">Super Trouper.*</a><br />')

      end
  end

  #   # Read a single album
    # Request: GET /albums/1
  #   Response: of a single album
  context 'GET to /albums/1' do
    it 'reads a single album' do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('Doolittle')
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
  #   it 'update a single album' do
  #     response = get('/albums/1')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('Doolittle')

  #     response = patch('/albums/1', title: 'OK Computer', release_year: '1997', artist_id: '1')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq('')

  #     response = get('/albums')

  #     expect(response.status).to eq(200)
  #     expect(response.body).to include('OK Computer')

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

        expect(response.status).to eq(200)
        expect(response.body).to match('<a href="/artists/1"> Pixies.*</a><br />')
        expect(response.body).to match('<a href="/artists/2"> ABBA.*</a><br />')
        expect(response.body).to match('<a href="/artists/3"> Taylor Swift.*</a><br />')
        expect(response.body).to match('<a href="/artists/4"> Nina Simone.*</a><br />')
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

  context 'GET /artists/:id' do
    it 'should return info about artist 1' do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end
  end
end
