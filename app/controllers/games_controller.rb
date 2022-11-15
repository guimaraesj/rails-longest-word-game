require 'json'
require 'open-uri'

class GamesController < ApplicationController
  # the solutions had this:
  VOWELS = %w(A E I O U Y)
  def new
    # my solution was this, but resolution solution makes sense.
    # @letters = [*'A'..'Z'].sample(10)

    # the solutions had this to force 5 vowels and 5 consonants. makes sense
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    # raise is equivalent to byebug, but raises an error on the html server
    ########### UNDERSTAND WHATS GOING ON HERE ######################
    @letters = params[:letters].split # L E T T E R into ["L", "E", "T", "T", "E", "R"]
    @word = (params[:word] || '').upcase # what does this do besides upcase???
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    # subtrair uma string menos a outra. Se for vazio, é pq está incluido.
    # (params[:word].upcase.chars - @letters).empty? # é preciso passar agora as @letters para array...... FALTA
    # das soluções:
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) } # explicar isto!
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found'] # retorna o valor true ou false
  end
end
