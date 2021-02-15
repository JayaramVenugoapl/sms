module Error
  class RoutingError < CustomError
    def initialize
      super(:routing_error, 405, 'No route matches')
    end
  end
end
