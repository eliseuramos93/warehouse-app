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
    product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5000, height: 100,
                                width: 70, depth: 75, supplier: supplier,
                                sku: 'CAD_GAMER-1234')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now, 
                          status: :pending)
    OrderItem.create!(product_model: product, order: order, quantity: 5)
    
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
    expect(page).not_to have_content 'Marcar como ENTREGUE'
    expect(StockProduct.count).to eq 5
    estoque = StockProduct.where(product_model: product, warehouse: warehouse).count
    expect(estoque).to eq 5
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
    product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5000, height: 100,
                                width: 70, depth: 75, supplier: supplier,
                                sku: 'CAD_GAMER-1234')
    order_1 = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now, 
                          status: :pending)
    order_2 = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now, 
                          status: :pending)
    OrderItem.create!(product_model: product, order: order_1, quantity: 5)
    OrderItem.create!(product_model: product, order: order_2, quantity: 5)
    
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order_2.code
    click_on 'Marcar como ENTREGUE'
    click_on 'Galpões & Estoque'
    click_on 'Meus Pedidos'
    click_on order_1.code
    click_on 'Marcar como CANCELADO' 

    # Assert
    expect(current_path).to eq order_path(order_1.id)
    expect(page).to have_content 'Status do Pedido: Cancelado'
    expect(page).not_to have_button 'Marcar como ENTREGUE'
    expect(page).not_to have_content 'Status do Pedido: Pendente'
    expect(StockProduct.count).to eq 5
  end
end