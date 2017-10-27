#encoding: utf-8
#frozen_string_literal: true

module Faker

  class BreakingBad < Base

    def self.character
      fetch('breaking_bad.character')
    end

    def self.episode
      fetch('breaking_bad.episode')
    end

  end #class BreakingBad

end #module Faker
