require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    # Arrange
    
    # Act
    visit root_path
    click_on 'Meus Pedidos'

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
    # Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    carla = User.create!(name: 'Carla', email: 'carla@email.com', password: '12345678') 

    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')

    order1 = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: 'pending')
    order2 = Order.create!(user: carla, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: 'delivered')
    order3 = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now, status: 'canceled')
    
    # Act
    login_as sergio
    visit root_path
    click_on 'Meus Pedidos'

    # Assert
    expect(page).to have_content order1.code
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content order2.code
    expect(page).to have_content 'Cancelado'
    expect(page).to have_content order3.code
    expect(page).not_to have_content 'Entregue'
  end

  it 'e visita um pedido' do
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

    order1 = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    # Act
    login_as sergio
    visit root_path
    click_on 'Meus Pedidos'
    click_on order1.code

    # Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content order1.code
    expect(page).to have_content "Galpão Destino: #{order1.warehouse.full_description}"
    expect(page).to have_content "Fornecedor: #{order1.supplier.corporate_name}"
    formatted_date = I18n.localize 1.day.from_now.to_date
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'e não visita pedidos de outros usuários' do
    # Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    andre = User.create!(name: 'André', email: 'andre@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')

    order1 = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    # Act
    login_as andre
    visit order_path(order1.id)

    # Assert
    expect(current_path).not_to eq order_path(order1.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este pedido.'
  end

  it 'e vê itens do pedido' do
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
    
    # criar 3 produtos: A, B, C
    product_a = ProductModel.create!(name: 'Produto A', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: supplier,
                                    sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: supplier,
                                    sku: 'PRODUTO-B')
    product_c = ProductModel.create!(name: 'Produto C', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: supplier,
                                    sku: 'PRODUTO-C')
                                    
    # vincular o produto A ao pedido
    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    # vincular produto B ao pedido
    OrderItem.create!(product_model: product_b, order: order, quantity: 12)

    # Act
    login_as sergio
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
  
    # Assert
    expect(page).to have_content 'Itens do Pedido'
    expect(page).to have_content '19 x Produto A'
    expect(page).to have_content '12 x Produto B'
    expect(page).not_to have_content 'Produto C'
  end
end
