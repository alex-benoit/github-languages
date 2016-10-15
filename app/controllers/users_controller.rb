require 'json'
require 'open-uri'

# User Controller
class UsersController < ApplicationController
  def show
    input_user = params[:user]
    access_token = '?access_token=' + ENV['github_token']

    @user = JSON.parse RestClient::Request.execute(
      method: :get,
      url: "https://api.github.com/users/#{input_user}#{access_token}"
    )

    user_repos = JSON.parse RestClient::Request.execute(
      method: :get,
      url: "https://api.github.com/users/#{input_user}/repos#{access_token}"
    )

    user_lang = {}
    total_bytes = 0
    user_repos.delete_if { |repo| repo['fork'] == true } .each do |repo|
      repo_lang = JSON.parse RestClient::Request.execute(
        method: :get,
        url: "#{repo['languages_url']}#{access_token}"
      )
      repo_lang.each do |lang, bytes|
        user_lang[lang] ||= 0
        user_lang[lang] += bytes
        total_bytes += bytes
      end
      @sorted_languages = user_lang.sort_by { |_lang, bytes| -bytes }
      @sorted_languages.each do |lang_pair|
        percentage = lang_pair[1] * 100.0 / total_bytes
        lang_pair << percentage
      end
    end
  rescue URI::InvalidURIError
    { 'error' => { 'message' => 'url error' } }
  rescue RestClient::ResourceNotFound
    { 'error' => { 'message' => 'rest ressource error' } }
  rescue RestClient::Forbidden
    { 'error' => { 'message' => 'forbidden' } }
  end

  private

  def round_languages (nb_lines)
    x = Math.log10(nb_lines).floor - 1
    (nb_lines / (10.0**x)).round * 10**x
  end
end
