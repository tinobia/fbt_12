class Category < ApplicationRecord
  include ActAsTree

  validates :name, presence: true
  validate :parent_cannot_be_self_or_descendants

  def parent_cannot_be_self_or_descendants
    return unless self_and_descendants.include? parent
    errors.add :parent,
      t("shared.error_messages.can_not_be_self_or_descendants")
  end
end
