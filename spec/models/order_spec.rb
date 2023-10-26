require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                    area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                    cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                  registration_number: '12.345.678/0001-90',
                                  full_address: 'Avenida Paulista, 1000', 
                                  city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

      # Act
      
      # Assert
      expect(order).to be_valid
    end

    it 'data estimada de entrega de ve ser obrigatória' do
       # Arrange
       order = Order.new
 
       # Act
       order.valid?

       # Assert
       expect(order.errors.include? :estimated_delivery_date).to be true  
    end

    it 'data estimada não deve ser 1 ou mais dias no passado' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)

      # Act
      order.valid?

      # Assert
      expect(order.errors[:estimated_delivery_date]).to include('deve ser futura.')
    end

    it 'data estimada não deve ser hoje' do
      # Arrange
      order = Order.new(estimated_delivery_date: Date.today)

      # Act
      order.valid?

      # Assert
      expect(order.errors[:estimated_delivery_date]).to include('deve ser futura.')
    end

    it 'data estimada deve ser igual ou maior do que amanhã' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)

      # Act
      order.valid?

      # Assert
      expect(order.errors.include? :estimated_delivery_date).to be false  
    end
  end

  describe 'gera um codigo aleatório' do
    it 'ao criar um novo pedido' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                    area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                    cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                  registration_number: '12.345.678/0001-90',
                                  full_address: 'Avenida Paulista, 1000', 
                                  city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

      # Act
      order.save!

      # Assert
      expect(order.code).not_to be_nil
      expect(order.code).not_to be_empty
      expect(order.code.length).to eq 8
    end

    it 'e o código é único' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                    area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                    cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                  registration_number: '12.345.678/0001-90',
                                  full_address: 'Avenida Paulista, 1000', 
                                  city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: '2023-11-15')

      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                    area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                    cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                  registration_number: '12.345.678/0001-90',
                                  full_address: 'Avenida Paulista, 1000', 
                                  city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
      original_code = order.code

      # Act
      order.update!(estimated_delivery_date: 1.month.from_now)

      # Assert
      expect(order.code).to eq original_code
    end
  end
end
