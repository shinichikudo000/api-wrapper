require 'faraday'
require 'json'

class MyAnimeList::V2::Client
    BASE_URL = 'https://api.myanimelist.net/v2'.freeze

    def initialize(client_id)
        @client_id = client_id
    end

    def get_top_anime(limit, type)
        request(
            method: :get,
            endpoint: "anime/ranking",
            params: { limit: limit, type: type },
        )
    end

    def get_seasonal_anime(limit, season, year)
        request(
        method: :get,
        endpoint: "anime/season/#{year}/#{season}",
        params: { limit: limit },
        )
    end

    def get_anime_details(anime_id)
        request(
        method: :get,
        endpoint: "anime/#{anime_id}",
        )
    end

    private

    def request(method:, endpoint:, params: {}, body: nil)
        # Convert params hash to a query string
        query_string = Faraday::Utils.build_nested_query(params)
        
        # Append query string to the endpoint
        full_endpoint = "#{endpoint}?#{query_string}"
        
        # Send request
        response = connection.public_send(method, full_endpoint, body)
        
        # Parse response
        if response.success?
            {
                body: response.body
            }
        else
        # Return a default value or an empty response
        return {}
        end
    rescue Faraday::Error => e
        puts e.inspect
        # Return a default value or an empty response
        return {}
    end

    def connection
        @connection ||= Faraday.new(url: BASE_URL) do |faraday|
            faraday.request :json
            faraday.response :json, content_type: /\bjson$/
            faraday.adapter Faraday.default_adapter
            faraday.headers['X-MAL-CLIENT-ID'] = @client_id
            faraday.headers['Content-Type'] = 'application/json'
        end
    end
end