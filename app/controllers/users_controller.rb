# User Controller
class UsersController < ApplicationController
  def show
    input_user = params[:user]
    client = GithubClient.new
    @user = client.find_user_info(input_user)
    all_repos_info = client.find_repos_info(input_user)
    @sorted_languages = all_repos_info[0]
    @total_stars = all_repos_info[1]
  end
end
