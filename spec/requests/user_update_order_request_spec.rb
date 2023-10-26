require 'rails_helper'

describe 'Usuário atualizado um pedido' do
  it 'e como entregue mas não é o dono dele' do
    # Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', 
                         password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', 
                                  city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', 
                                brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', 
                                email: 'brazil@apple.com')
    order = Order.create!(user: sergio, warehouse: warehouse, 
                          supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now)
    andre = User.create!(name: 'André', email: 'andre@email.com', 
                         password: '12345678')

    # Act
    login_as andre
    post delivered_order_path(order.id)

    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e como cancelado mas não é o dono dele' do
    # Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', 
                         password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', 
                                  city: 'Guarulhos', area: 100_000, 
                                  address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', 
                                brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', 
                                email: 'brazil@apple.com')
    order = Order.create!(user: sergio, warehouse: warehouse, 
                          supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now)
    andre = User.create!(name: 'André', email: 'andre@email.com', 
                         password: '12345678')

    # Act
    login_as andre
    post canceled_order_path(order.id)

    # Assert
    expect(response).to redirect_to(root_path)
  end
end
