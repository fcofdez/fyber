module Fyber

  class Error < StandardError

    def self.from_response(response)
      status = response[:status].to_i
      if klass = case status
                   when 400 then Fyber::BadRequest
                   when 403 then Fyber::Forbidden
                   when 404 then Fyber::NotFound
                   when 500 then Fyber::InternalServerError
                 end
        klass.new(klass)
      end
    end
  end

  class InvalidTokenResponse < Exception
  end

  class BadRequest < Exception
  end

  class NotFound < Exception
  end

  class InternalServerError < Exception
  end

  class Forbidden < Exception
  end
end
