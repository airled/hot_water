require 'rails_helper'

RSpec.describe Offdate, type: :model do
  it { should have_many(:addresses) }
end
