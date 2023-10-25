require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path
    click_on 'Registrar Pedido'

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', 
                                  description: 'Galpão destinado para cargas internacionais')
    Warehouse.create!(name: 'Galpão Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000, 
                      address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')

    Supplier.create!(corporate_name: 'Samsung Computadores', brand_name: 'Samsung',
                    registration_number: '87.654.321/0001-90',
                    full_address: 'Av Nações Unidas, 2000', 
                    city: 'São Paulo', state: 'SP', email: 'contato@samsung.com')
    supplier = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                                registration_number: '12.345.678/0001-90',
                                full_address: 'Avenida Paulista, 1000', 
                                city: 'São Paulo', state: 'SP', email: 'brazil@apple.com')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')
    

    # Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select warehouse.full_description, from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista', with: '20/12/2039'
    click_on 'Gravar'
    
    # Assert
    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'Pedido: ABC12345'
    expect(page).to have_content 'Galpão Destino: GRU | Aeroporto SP'
    expect(page).to have_content 'Fornecedor: Apple do Brasil'
    expect(page).to have_content 'Data Prevista de Entrega: 20/12/2039'
    expect(page).to have_content 'Usuário Responsável: Sergio <sergio@email.com>'
    expect(page).not_to have_content 'Galpão Rio'
  end
end