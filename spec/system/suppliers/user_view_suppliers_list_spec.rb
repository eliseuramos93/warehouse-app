require 'rails_helper'

describe 'Usuário visita lista de fornecedores' do
  it 'a partir da página inicial' do
    # Arrange

    # Act
    visit root_path
    within 'nav' do 
      click_on 'Fornecedores'
    end

    # Assert
    expect(current_path).to eql suppliers_path
    expect(page).to have_content 'Lista de Fornecedores'
  end

  it 'e vê os fornecedores cadastrados' do
    # Arrange
    Supplier.create!(corporate_name: 'Apple do Brasil', brand_name: 'Apple',
                    registration_number: '12.345.678/0001-90',
                    full_address: 'Avenida Paulista, 1000', city: 'São Paulo',
                    state: 'SP', email: 'brazil@apple.com')
    # Act
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(page).to have_content 'Fornecedor'
    expect(page).to have_content 'Localização'
    expect(page).to have_content 'Apple'
    expect(page).to have_content 'São Paulo - SP'
    expect(page).not_to have_content 'Não existem fornecedores cadastrados'
  end

  it 'e não existem fornecedores cadastrados' do 
    # Arrange
    
    # Act
    visit root_path
    click_on 'Fornecedores'

    # Assert
    expect(page).to have_content 'Não existem fornecedores cadastrados'
    expect(page).not_to have_content 'Localização'
  end

  it 'e retorna para página inicial' do
    # Arrange

    # Act
    visit root_path 
    click_on 'Fornecedores'
    click_on 'Voltar'

    # Assert
    expect(current_path).to eql root_path
  end
end