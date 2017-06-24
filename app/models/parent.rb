#File name: parent.rb
#Class name: Parent
#Description:Validates parent's attributes
class Parent < ApplicationRecord
  has_many :alumns
  validates :parent_cpf, :cpf => true
  has_secure_password
  before_save :validates_password

  validates :name, presence: { message: "não pode estar em branco" },
            length: { minimum: 5,
                      maximum: 64,
                     :too_short => "deve possuir no mínimo 5 caracteres",
                     :too_long => "deve possuir no máximo 64 caracteres" }


  before_create{
    generate_token(:authorization_token)
  }

  def get_age
    DateTime.now.year - self.birth_date.year
  end

  private
  def validates_password
    if self.password_digest.nil?
      validates :password, presence:true,
      length: { minimum: 8}
    end
  end

  def generate_token(column)
    begin
      self[column]= SecureRandom.urlsafe_base64
    end while Parent.exists?(column => self[column])
  end

end
