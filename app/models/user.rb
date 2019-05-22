class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :client
  has_one :partner
  enum kind: [:admin, :normal]
  validates_uniqueness_of :federal_registration

  def update_password(current_password, password, password_confirmation)
    msg ||= I18n.t("models.user.errors.invalid_password") unless valid_password?(current_password)
    msg ||= I18n.t("models.user.errors.password_not_match") unless password == password_confirmation
    msg.nil? ? update(password: password, password_confirmation: password_confirmation) : errors.add(:password, msg)
    msg.nil?
  end
end
