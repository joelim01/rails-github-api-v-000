class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

    def create
      response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: ENV["GITHUB_CLIENT"], client_secret: ENV["GITHUB_SECRET"],code: params[:code]}, {'Accept' => 'application/json'}
      body = JSON.parse(response.body)
      session[:token] = body["access_token"]

      user_resp = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}

      user = JSON.parse(user_resp.body)
      session[:username] = user["login"]

      redirect_to root_path
    end

end
