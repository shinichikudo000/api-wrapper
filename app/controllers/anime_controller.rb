class AnimeController < ApplicationController
    def top_anime
        @anime = @client.get_top_anime(10, 'all')
        @top_10_anime = @anime[:body]
    end
  
    def show
        anime_id = params[:id] 
        @anime_details = @client.get_anime_details(anime_id)
    end
  
    def seasonal_anime
        @anime = @client.get_seasonal_anime(10, 'spring', 2023)
        @seasonal_anime = @anime[:body]
        render 'seasonal_anime'
    end
end