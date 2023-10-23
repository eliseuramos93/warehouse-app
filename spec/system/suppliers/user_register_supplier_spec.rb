require 'rails_helper'

describe 'Usuário cadastra um fornecedor' do
  it 'a partir da tela inicial' do
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Criar Fornecedor'

    # Assert
    expect(current_path).to eql new_supplier_path
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

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Criar Fornecedor'
    fill_in 'Razão social', with: 'Arcos Dourados LTDA'
    fill_in 'Nome fantasia', with: "McDonald's"
    fill_in 'CNPJ', with: "09.876.543/0001-21"
    fill_in 'Endereço', with: 'Av. Rebouças, 2000'
    fill_in 'Cidade', with: 'São Paulo'
    fill_in 'Estado', with: 'SP'
    fill_in 'E-mail', with: 'ronald@mcdonalds.com.br'
    click_on 'Criar Fornecedor'

    # Assert
    expect(page).to have_content "Informações sobre McDonald's"
    expect(page).to have_content 'Fornecedor criado com sucesso'
    expect(page).to have_content 'Razão social: Arcos Dourados LTDA'
    expect(page).to have_content "Nome fantasia: McDonald's"
    expect(page).to have_content 'CNPJ: 09.876.543/0001-21'
    expect(page).to have_content 'Endereço: Av. Rebouças, 2000. São Paulo - SP'
    expect(page).to have_content 'E-mail: ronald@mcdonalds.com.br'
  end

  it 'com dados incompletos' do 
    # Arrange

    # Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Criar Fornecedor'
    fill_in 'Razão social', with: ''
    fill_in 'Nome fantasia', with: "McDonald's"
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: 'Av. Rebouças, 2000'
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: 'SP'
    fill_in 'E-mail', with: 'ronald@mcdonalds.com.br'
    click_on 'Criar Fornecedor'

    # Assert
    expect(page).to have_content "Fornecedor não cadastrado"
    expect(page).to have_content 'Razão social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
  end
end