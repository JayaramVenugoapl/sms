require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  it { should belong_to(:account) }
end