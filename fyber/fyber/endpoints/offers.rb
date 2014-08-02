module Fyber
  class Client
    module Offers
      def offers(uid, pub0, page)
        options = options(uid, pub0, page)
        response = @conn.get offers_path, options
        Fyber::Offers.new(response.body)
      end

      def offers_path
        "feed/v1/offers.json"
      end
    end
  end
end
