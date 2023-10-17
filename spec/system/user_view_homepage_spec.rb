require 'rails_helper'

describe 'Usuário visita tela inicial' do 
  it 'e vê o nome da app' do
    # Arrange (único bloco que pode estar vazio)

    # Act
    visit('/')

    # Assert
    expect(page).to have_content('Galpões & Estoque')
  end
end