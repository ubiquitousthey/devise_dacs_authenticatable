class User < ActiveRecord::Base
  devise :dacs_authenticatable, :rememberable, :timeoutable

  def active_for_authentication?
    super && !deactivated
  end
end