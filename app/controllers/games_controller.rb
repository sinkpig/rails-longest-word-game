# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...8).map { ('A'..'Z').to_a[rand(26)] }
    vowels = (0...2).map { %w[A E I O U][rand(5)] }
    @letters.concat vowels
  end

  def score
    @letters = params[:letters].split(' ')
    @word = (params[:word] || '').upcase
    @score = 0
    @feedback = "Sorry but #{@word} isn't a valid english word"

    unless included?(@word, @letters)
      @feedback = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
    end

    if included?(@word, @letters) && word_exists?(@word)
      @feedback = "Congratulations #{@word} is a valid english word and is part of the grid!"
      @score += 10 * @word.length
    end
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def word_exists?(word)
    new_link = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(new_link.read)
    json['found']
  end
end
