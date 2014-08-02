require 'json'

module Fyber
  class Offers
    attr_accessor :document
    def initialize(response)
      @document = response
    end
  end
end
