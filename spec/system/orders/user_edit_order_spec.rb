require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do 
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

    # Act
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    sergio = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    andre = User.create!(name: 'André', email: 'andre@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    apple = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                             registration_number: '12.345.678/0001-90',
                             full_address: 'Avenida Paulista, 1000', 
                             city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
    samsung = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronicos LTDA',
                               registration_number: '123456789000190', 
                               full_address: 'Av Nações Unidas, 1000', city: 'São Paulo', 
                               state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: sergio, warehouse: warehouse, supplier: apple, 
                          estimated_delivery_date: 1.day.from_now)
    # Act
    login_as sergio
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: 20.days.from_now.to_date
    select samsung.corporate_name, from: 'Fornecedor'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content "Pedido atualizado com sucesso."
    expect(page).to have_content "Fornecedor: #{samsung.corporate_name}"
    formatted_date = I18n.localize 20.days.from_now.to_date
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'caso seja responsável' do 
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
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq root_path
  end
end