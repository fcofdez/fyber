module Fyber

  class Offer

    def initialize(offer_json)
      @offer = offer_json
    end

  end

  class Offers < Array

    def initialize(response)
      response["offers"].each do |offer|
        self.push(Offer.new(offer))
      end
    end

  end

end
