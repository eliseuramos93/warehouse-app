require 'rails_helper'

describe 'Usuário vê detalhes de um fornecedor' do
  it 'e vê informações adicionais' do
    # Arrange
    Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                    registration_number: '12.345.678/0001-90',
                    full_address: 'Avenida Paulista, 1000', city: 'São Paulo',
                    state: 'SP', email: 'brazil@apple.com')

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Apple'

    # Assert
    expect(page).to have_content 'Informações sobre Apple'
    expect(page).to have_content 'Razão social: Apple do Brasil'
    expect(page).to have_content 'Nome fantasia: Apple'
    expect(page).to have_content 'CNPJ: 12.345.678/0001-90'
    expect(page).to have_content 'Endereço: Avenida Paulista, 1000. São Paulo - SP'
    expect(page).to have_content 'E-mail: brazil@apple.com'
  end

  it 'e volta para tela inicial' do 
    # Arrange
    Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
      registration_number: '12.345.678/0001-90',
      full_address: 'Avenida Paulista, 1000', city: 'São Paulo',
      state: 'SP', email: 'brazil@apple.com')
    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Apple'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eql(suppliers_path)
  end
end