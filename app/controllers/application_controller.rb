class ApplicationController < ActionController::Base
    before_action :initialize_controller

    private

    def initialize_controller
        client_id = ENV["CLIENT_ID"]
        @client ||= MyAnimeList::V2::Client.new(client_id)
    end
end
