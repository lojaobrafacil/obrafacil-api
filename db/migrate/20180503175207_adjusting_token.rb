class AdjustingToken < ActiveRecord::Migration[5.1]
  def change
    reversible do |direction|
      direction.up do
        begin
          User.find_each do |user|
            user.uid = user.email
            user.tokens = nil
            user.save!
          end
        rescue
          p "User model not exist anymore"
        end
      end
    end
  end
end
