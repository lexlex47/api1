class AccessToken < ApplicationRecord
  belongs_to :user
  after_initialize :generate_token

  private

  def generate_token 
    loop do
      # 如果token已经set了，已经生成的token在db中没有，则会跳出，换句话说就是生成了一个独一无二的token
      break if token.present? && !AccessToken.where.not(id: id).exists?(token: token)
      # 使用的Ruby自动生成token
      self.token = SecureRandom.hex(10)
    end
  end

end
