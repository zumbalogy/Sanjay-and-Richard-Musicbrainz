require 'bundler/setup'
require 'open-uri'
Bundler.require

# require 'sinatra'
# require 'sinatra/reloader'
# require 'pry'
# require 'httparty'
# require 'musicbrainz'
# require 'nokogiri'

# music_info = Musicbrainz.search(balbalblab)

MusicBrainz.configure do |c|
    # Application identity (required)
    c.app_name = "My Ruby Music App"
    c.app_version = "1.0"
    c.contact = "support@mymusicapp.com"
end


get "/" do
    erb :index
end


post "/" do
    @keys = [:youtube, :soundcloud, :fanpage, :official_homepage]
  
    @artist = params[:artist]
    # Search for artists
    @suggestions = MusicBrainz::Artist.search(@artist)
    @suggestions = @suggestions[0]
  
    # Find artist by unique id
    @result_data = MusicBrainz::Artist.find(@suggestions[:id])
    @albums = @result_data.release_groups
  
    @tube_search = HTTParty.get("https://www.youtube.com/results?search_query=#{@artist.gsub(" ", "+")}")
    @doc = Nokogiri::HTML(open("https://www.youtube.com/results?search_query=#{@artist.gsub(" ", "+")}"))
    @doc = @doc.xpath('//h3/a')
    @video_names = []
    @doc.each do |foo|
        bar = foo.attributes['href'].to_s
        @video_names << bar unless bar[1] != 'w' 
    end
    @video_names = @video_names[0..3]
    @doc = Nokogiri::HTML(open("#{@result_data.urls[:wikipedia]}"))
    @doc = @doc.xpath('//div/div/div/p')
    @doc = @doc.first


    # @wiki_search = HTTParty.get(@result_data.urls[:wikipedia])
    # @tube_result = Nokogiri.something(@tube_search)
    # @wiki_result = Nokogiri.something(@wiki_search)
    erb :index
end