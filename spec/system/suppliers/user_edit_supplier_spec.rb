require 'rails_helper'

describe 'Usuário edita um fornecedor' do
  it 'a partir da página de detalhes' do
    # Arrange
    s = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                        registration_number: '12.345.678/0001-90',
                        full_address: 'Avenida Paulista, 1000', city: 'São Paulo',
                        state: 'SP', email: 'brazil@apple.com')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Apple'
    click_on 'Editar'

    # Assert
    expect(page).to have_content 'Editar Fornecedor'
    expect(page).to have_field 'Razão social'
    expect(page).to have_field 'Nome fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'E-mail'
  end

  it 'com sucesso' do
    # Arrange
    s = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
      registration_number: '12.345.678/0001-90',
      full_address: 'Avenida Paulista, 1000', city: 'São Paulo',
      state: 'SP', email: 'brazil@apple.com')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Apple'
    click_on 'Editar'
    fill_in 'Razão social', with: 'Apple Computer Brasil LTDA'
    fill_in 'CNPJ', with: '00.623.904/0003-35'
    fill_in 'Endereço', with: 'Rua Leopoldo Couto de Magalhães Jr., 700, 7º andar'
    click_on 'Atualizar Fornecedor'

    # Assert
    expect(page).to have_content 'Fornecedor atualizado com sucesso'
    expect(page).to have_content 'Razão social: Apple Computer Brasil LTDA'
    expect(page).to have_content 'CNPJ: 00.623.904/0003-35'
    expect(page).to have_content 'Endereço: Rua Leopoldo Couto de Magalhães Jr., 700, 7º andar. São Paulo - SP'
  end

  it 'e mantém os campos obrigatórios' do
    # Arrange
    s = Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
      registration_number: '12.345.678/0001-90',
      full_address: 'Avenida Paulista, 1000', city: 'São Paulo',
      state: 'SP', email: 'brazil@apple.com')
    
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Apple'
    click_on 'Editar'
    fill_in 'Razão social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: ''
    click_on 'Atualizar Fornecedor'  

    # Assert
    expect(page).to have_content 'Não foi possível atualizar fornecedor'
    expect(page).to have_field 'Razão social', with: ''
    expect(page).to have_field 'CNPJ', with: ''
    expect(page).to have_field 'Endereço', with: ''
  end
end