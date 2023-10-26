require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
    # Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
    order = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    andre = User.create!(name: 'André', email: 'andre@email.com', password: '12345678')

    # Act
    login_as andre
    patch order_path(order.id), params: { order: {estimated_delivery_date: 2.days.from_now}}

    # Assert
    expect(response).to redirect_to(root_path)
  end
end
