require 'open-uri'
require 'json'
require 'pry-byebug'

class LongestWordsController < ApplicationController



  def game
    @grid = generate_grid(10).join(" ")
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @start_time = Time.parse(params[:start_time])
    @result = run_game(params[:word], params[:grid], @start_time, @end_time)
  end

  private


  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = (0...grid_size).map { ('a'..'z').to_a[rand(26)] }
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    # On cree un hash ou on va tout stocker
    # 1 - On check si attempt est dans la grille et en anglais et on recupere la traduction
    result = translation(attempt, grid)

    # Add infos inside the hash
    result[:score] = result[:score].fdiv(end_time - start_time)
    result[:time] = end_time - start_time

    return result
  end

  def translation(attempt, grid)
    result = {}
    attempt_a = attempt.split("") # passe le attempt en array
    if attempt_a.all? { |letter| grid.include?(letter) }
      # Si le mot est dans la grille on check la traduction
      url = "https://api-platform.systran.net/translation/text/translate?input=#{attempt}&source=auto&target=fr&withSource=false&withAnnotations=false&backTranslation=false&encoding=utf-8&key=2fce6a6e-af77-4840-921d-5dbbe3df9efd"
      begin
        traduction_api = JSON.parse(open(url).read)
      rescue
        # si le mot existe == traduction ok
         result[:message] = "Ce n'est pas un mot de la langue anglaise"
         result[:translation] = "N/a"
         result[:score] = 0
      else
         result[:translation] = traduction_api["outputs"][0]["output"]
         result[:message] = "Bien joué !"
         result[:score] = 1
      end
    else
       result[:message] =  "Ce mot n'est pas présent dans la grille"
       result[:translation] = "N/A"
       result[:score] = 0
    end
    result
  end

end
