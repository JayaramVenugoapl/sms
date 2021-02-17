module Error
  class UnauthorizedError < CustomError
    def initialize
      super("Invalid credentials", 403)
    end
  end
end
