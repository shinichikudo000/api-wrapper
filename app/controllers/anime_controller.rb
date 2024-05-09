class AnimeController < ApplicationController
    def top_anime
        @top_10_anime = @client.get_top_anime(10, 'all')
    end
  
    def show
        anime_id = params[:id] 
        @anime_details = @client.get_anime_details(anime_id)
    end
  
    def seasonal_anime
        @seasonal_anime = @client.get_seasonal_anime(10, 'spring', 2023)
    end
end