require 'rails_helper'

describe 'Usuário busca por um pedido' do
  it 'a partir do menu' do
    # Arrange
    user = User.create!(name: 'João', email: 'joao@email.com', password: 'password')

    # Act
    login_as(user)
    visit root_path

    # Assert
    within 'header nav' do
      expect(page).to have_field('Buscar Pedido')
      expect(page).to have_button('Buscar')
    end
  end

  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path

    # Assert
    within ('header nav') do 
      expect(page).not_to have_field('Buscar Pedido')
      expect(page).not_to have_button('Buscar')
    end
  end

  it 'e encontra um pedido' do
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

    # Act
    login_as user
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    # Assert
    expect(page).to have_content "Resultados da busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content "Galpão Destino: #{warehouse.full_description}"
    expect(page).to have_content "Fornecedor: #{supplier.corporate_name}"
  end

  it 'e encontra múltiplos pedidos' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse_a = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    warehouse_b = Warehouse.create!(name: 'Aeroporto RJ', code: 'SDU', city: 'Rio de Janeiro', 
                                  area: 100_000, address: 'Avenida do Porto, 1000', 
                                  cep: '25000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
    
    
    
    
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU12345')
    order_a = Order.create!(user: user, warehouse: warehouse_a, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU54321')
    order_b = Order.create!(user: user, warehouse: warehouse_a, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('SDU67890')
    order_c = Order.create!(user: user, warehouse: warehouse_b, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    # Act
    login_as user
    visit root_path
    fill_in 'Buscar Pedido', with: 'GRU'
    click_on 'Buscar'

    # Assert
    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'GRU12345'
    expect(page).to have_content 'GRU54321'
    expect(page).not_to have_content 'SDU67890'
    expect(page).to have_content "Galpão Destino: #{warehouse_a.full_description}"
    expect(page).not_to have_content "Galpão Destino: #{warehouse_b.full_description}"
  end
end
