require 'rails_helper'

describe 'Usuário vê o estoque' do
  it 'na tela do galpão' do 
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
    order = Order.create!(user: user, warehouse: warehouse, 
                          supplier: supplier, 
                          estimated_delivery_date: 1.day.from_now, 
                          status: :delivered)
    product_a = ProductModel.create!(name: 'Cadeira Gamer', weight: 5,
                                    height: 70, width: 75, depth: 80,
                                    sku: 'CGMER-XPTO-888', supplier: supplier)
    product_b = ProductModel.create!(name: 'Soundbar', weight: 5,
                                    height: 70, width: 75, depth: 80,
                                    sku: 'SDBAR-XPTO-777', supplier: supplier)
    product_c = ProductModel.create!(name: 'Notebook', weight: 5,
                                    height: 70, width: 75, depth: 80,
                                    sku: 'NTBOK-XPTO-666', supplier: supplier)
    3.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_a) }
    2.times { StockProduct.create!(order: order, warehouse: warehouse, product_model: product_b) }

    # Act
    login_as user
    visit root_path
    click_on warehouse.name
    
    # Assert
    expect(page).to have_content 'Itens em Estoque'
    expect(page).to have_content "3 x #{product_a.sku}"
    expect(page).to have_content "2 x #{product_b.sku}"
    expect(page).not_to have_content product_c.sku
  end
end