require 'faraday'

class MyAnimeList::V2::Client
    BASE_URL = 'https://api.myanimelist.net/v2'.freeze

    def get__top_anime(limit, type)
        request(
            method: :get,
            endpoint: "anime/ranking",
            params: { limit: limit, type: type }
        )
    end

    def get_seasonal_anime(limit, season, year)
        request(
            method: :get,
            endpoint: "anime/season/#{year}/#{season}",
            params: { limit: limit}
        )
    end

    def get_anime_details(anime_id)
        request(
            method: :get,
            endpoint: "anime/#{anime_id}"
        )
    end

    private

    def request(method:, endpoint:, params: {}, headers: {}, body: {})
        response = client.public_send(method, endpoint, params, body)
    end

    def connection
        @connection ||= Faraday.new(url: BASE_URL) do |faraday|
            faraday.request :json
            faraday.response :json, content_type: /\bjson$/
            faraday.adapter Faraday.default_adapter
            faraday.headers['X-MAL-CLIENT-ID'] = @client_id
        end
    end
    
    def request(method:, endpoint:, params: {}, headers: {}, body: {})
        response = connection.public_send(method, endpoint, params, body)
        
        return JSON.parse(response.body).with_indifferent_access if response.success?
    rescue Faraday::Error => e
        puts e.inspect
    end
    
end