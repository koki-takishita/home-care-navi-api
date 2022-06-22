class Specialist < User
  default_scope { where(user_type: 1) }
  before_save :set_enum_specialist
  has_one :office, foreign_key: "user_id", dependent: :destroy

  def set_enum_specialist
    self.user_type = 1
  end

  def set_user_type(type)
    set_specialist if type == :specialist
  end

  private

  def set_specialist
    self.specialist!
  end

end
