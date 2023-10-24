require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    it 'name is mandatory' do 
      # Arrange
      samsung = Supplier.create!(
        brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA', 
        registration_number: '123456789000190', full_address: 'Av Nações Unidas, 1000', 
        city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br'
      )
      pm = ProductModel.new(
        name: '', weight: 8000, width: 70, height: 45, depth: 10, 
        sku: 'TV32-SAMSU-XPTO90', supplier: samsung
      )

      # Act

      # Assert
      expect(pm).not_to be_valid
    end

    it 'sku is mandatory' do
      # Arrange
      samsung = Supplier.create!(
        brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA', 
        registration_number: '123456789000190', full_address: 'Av Nações Unidas, 1000', 
        city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br'
      )
      pm = ProductModel.new(
        name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, 
        sku: '', supplier: samsung
      )

      # Act

      # Assert
      expect(pm).not_to be_valid
    end
  end
end
