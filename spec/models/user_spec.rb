require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
  	id 'should validate uniqueness of email' do
  		
  	end
    it should validate_uniqueness_of :email 
    it { should validate_uniqueness_of :password }
    it { should validate_uniqueness_of :token }
  end
end
