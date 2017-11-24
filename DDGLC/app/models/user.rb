class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :code, presence: true, uniqueness: { case_sensitive: false }, format: {with: /(\A[A-ZÄÖÜ][a-zäöüß][A-ZÄÖÜ][a-zäöüß])\z|(\AAdmin\z)/}
  validates :role, presence: true
  validates :password, presence: true, length: { in: 5..15 }, allow_nil: true


  has_secure_password

  ROLES = %i[guest employee manager admin].freeze

  def self.options_for_select(table='lemma')
    order('LOWER(code)').map { |user| [user.code, user.id] }
  end

  def admin?
    role == 'admin' && activated == true
  end

  def manager?
    role == 'manager' && activated == true
  end

  def employee?
    role == 'employee' && activated == true
  end

  def guest?
    role == 'guest' && activated == true
  end
end
