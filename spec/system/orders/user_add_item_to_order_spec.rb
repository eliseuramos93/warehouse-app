require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do
  it 'com sucesso' do
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

    order = Order.create!(user: sergio, warehouse: warehouse, supplier: supplier,
                          estimated_delivery_date: 1.day.from_now)
    
    product_a = ProductModel.create!(name: 'Produto A', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: supplier,
                                    sku: 'PRODUTO-A')
    product_b = ProductModel.create!(name: 'Produto B', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: supplier,
                                    sku: 'PRODUTO-B')

    # Act
    login_as sergio
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    select 'Produto A', from: 'Produto'
    fill_in 'Quantidade', with: 8
    click_on 'Gravar'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content '8 x Produto A'
    expect(page).not_to have_content 'Produto B'
  end

  it 'e não vê produtos de outro fornecedor' do
    # Arrange
    user = User.create!(name: 'Billy', email: 'billy@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    samsung = Supplier.create!(brand_name: 'Samsung', 
                              corporate_name: 'Samsung Eletronicos LTDA',
                              registration_number: '123456789000190', 
                              full_address: 'Av Nações Unidas, 1000',
                              city: 'São Paulo', state: 'SP', 
                              email: 'sac@samsung.com.br')

    lg = Supplier.create!(brand_name: 'LG', corporate_name: 'LG do Brasil',
                          registration_number: '23456789000150', 
                          full_address: 'Av Ibirapuera, 300', city: 'São Paulo',
                          state: 'SP', email: 'contato@lg.com.br')
    order = Order.create!(user: user, warehouse: warehouse, supplier: samsung,
                          estimated_delivery_date: 1.day.from_now)
    
    product_samsung = ProductModel.create!(name: 'Produto A', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: samsung,
                                    sku: 'PRODUTO-A')
    product_lg = ProductModel.create!(name: 'Produto B', weight: 1000, height: 10,
                                    width: 20, depth: 30, supplier: lg,
                                    sku: 'PRODUTO-B')

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    # Assert
    expect(page).to have_content 'Produto A'
    expect(page).not_to have_content 'Produto B'
  end
end