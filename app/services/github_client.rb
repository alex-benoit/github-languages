# Class used for GitHub API calls in User Controller
class GithubClient
  # Return {user-gh-profile-info}
  def find_user_info(input_user)
    base_url = "https://api.github.com/users/#{input_user}?access_token="
    return JSON.parse Curl::Easy.perform(base_url + ENV['github_token']) { |curl| curl.headers['User-Agent'] = 'github-languages' }.body_str
  rescue => e
    puts e
  end

  # Returns [ [array-of-languages-and-info] , number-of-total-stars ]
  def find_repos_info(input_user)
    base_url = "https://api.github.com/users/#{input_user}/repos?access_token="
    user_repos = JSON.parse Curl::Easy.perform(base_url + ENV['github_token']) { |curl| curl.headers['User-Agent'] = 'github-languages' }.body_str
    repos_info = []
    user_lang = {}
    total_stars = 0
    total_bytes = 0
    user_repos.delete_if { |repo| repo['fork'] == true }.each do |repo|
      total_stars += repo['stargazers_count']
      repo_lang = JSON.parse Curl::Easy.perform("#{repo['languages_url']}?access_token=" + ENV['github_token']) { |curl| curl.headers['User-Agent'] = 'github-languages' }.body_str
      repo_lang.each do |lang, bytes|
        user_lang[lang] ||= 0
        user_lang[lang] += bytes
        total_bytes += bytes
      end
    end
    sorted_languages = user_lang.sort_by { |_lang, bytes| -bytes }
    sorted_languages.each do |lang_info|
      lang_info[1] = dynamic_round(lang_info[1]) # Round number of characters
      lang_info << dynamic_round(lang_info[1] / 25) # Lines of code
      raw_percentage = (lang_info[1] * 100.0 / total_bytes)
      lang_info << (raw_percentage.between?(0, 0.05) ? 0.1 : raw_percentage.round(1)) # Percentage of usage
    end
    repos_info << sorted_languages
    repos_info << total_stars
  rescue => e
    puts e
  end

  private

  def dynamic_round(nb_lines)
    case nb_lines
    when 0..4
      return 5
    when 5..100
      nb_lines.round(-1)
    else
      x = Math.log10(nb_lines).floor - 1
      (nb_lines / (10.0**x)).round * 10**x
    end
  end
end
