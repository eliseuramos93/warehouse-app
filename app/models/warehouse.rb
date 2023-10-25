class Warehouse < ApplicationRecord
  # não passar mais do que uma regra de validação por linha
  validates :name, :code, :description, :city, :area, :address, :cep, presence: true
  validates :code, length: { is: 3 }
  validates :code, uniqueness: true

  has_many :orders

  def full_description
    "#{code} | #{name}"
  end
end
