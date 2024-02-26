require "open-uri"
class GamesController < ApplicationController
  def new
    @letters = []
    # it appends chosen lowercase letter from the alphabet to the array.
    # ("a".."z").to_a generates an array containing all lowercase letters from 'a' to 'z
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @grid = @letters.join("")
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @letter_in_grid = letter_in_grid(@word, @letters)
    @english_word = english_word?(@word)
  end

  def letter_in_grid(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json ['found']
  end

  def check_word_validity(word, letters)
    if !letter_in_grid(word, letters)
      'The word can’t be built out of the original grid ❌'
    elsif !english_word?(word)
      'The word is valid according to the grid, but is not a valid English word ❌'
    else
      'The word is valid according to the grid and is an English word ✅'
    end
  end
end
