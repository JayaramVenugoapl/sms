module Error
  class UnauthorizedError < CustomError
    def initialize
      super(:unauthorized_request, 401, 'Invalid credentials')
    end
  end
end
