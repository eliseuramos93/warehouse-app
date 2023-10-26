require 'rails_helper'

describe 'Usuário informa novo status de pedido' do
  it 'e pedido foi entregue' do
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
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now, 
                          status: :pending)
    
    # Act
    login_as user
    visit root_path 
    click_on  'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como ENTREGUE' 

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status do Pedido: Entregue'
    expect(page).not_to have_content 'Marcar como CANCELADO'
  end

  it 'e pedido foi cancelado' do
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
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now, 
                          status: :pending)
    
    # Act
    login_as user
    visit root_path 
    click_on  'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como CANCELADO' 

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status do Pedido: Cancelado'
    expect(page).not_to have_button 'Marcar como ENTREGUE'
    expect(page).not_to have_content 'Status do Pedido: Pendente'
  end
end