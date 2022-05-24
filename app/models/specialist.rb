class Specialist < User
  
  def set_user_type(type)
    set_specialist if type == :specialist
  end

  private

  def set_specialist
    self.specialist!
  end

end