module UsersHelper
  def full_name user
    if user.first_name.present? || user.last_name.present?
      "#{user.first_name} #{user.last_name}"
    else
      t "shared.anonymous"
    end
  end
end
