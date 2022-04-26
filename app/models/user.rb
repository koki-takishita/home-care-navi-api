class User < ApplicationRecord

=======
  has_secure_password
  enum user_type: { customer: 0, specialist: 1 }
>>>>>>> origin
end
