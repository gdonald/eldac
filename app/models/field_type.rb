class FieldType < ActiveRecord::Base

  has_many :fields, dependent: :destroy

  def to_s
    name
  end
  
end
