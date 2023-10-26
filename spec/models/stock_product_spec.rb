require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'ger um número de série' do
    it 'ao criar um StockProduct' do
      # arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                    area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                    cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                  registration_number: '12.345.678/0001-90',
                                  full_address: 'Avenida Paulista, 1000', 
                                  city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
      order = Order.create!(user: user, warehouse: warehouse, 
                            supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now, 
                            status: :delivered)
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5,
                                     height: 70, width: 75, depth: 80,
                                     sku: 'CGMER-XPTO-888', supplier: supplier)

      # act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse,
                                           product_model: product)
      # assert
      expect(stock_product.serial_number.length).to eq 20
    end

    it 'e não é modificado em atualizações' do
      # arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                    area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                    cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      other_warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', city: 'Rio de Janeiro', 
                                    area: 80_000, address: 'Avenida do Porto, 500', 
                                    cep: '25000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                  registration_number: '12.345.678/0001-90',
                                  full_address: 'Avenida Paulista, 1000', 
                                  city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
      order = Order.create!(user: user, warehouse: warehouse, 
                            supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now, 
                            status: :delivered)
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5,
                                     height: 70, width: 75, depth: 80,
                                     sku: 'CGMER-XPTO-888', supplier: supplier)
      stock_product = StockProduct.create!(order: order, warehouse: warehouse,
                                           product_model: product)
      original_serial_number = stock_product.serial_number

      # act
      stock_product.update!(warehouse: other_warehouse)
      # assert
      expect(stock_product.serial_number).to eq original_serial_number
    end
  end
end
