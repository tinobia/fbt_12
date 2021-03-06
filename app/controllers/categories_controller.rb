class CategoriesController < ApplicationController
  def show
    if (@category = Category.find_by id: params[:id])
      self_and_descendants = @category.self_and_descendants.pluck(:id).join(",")
      @tours = Tour.under_these_categories(self_and_descendants)
        .order_by_created_at.page(params[:page]).per Settings.per_page.tour
    else
      flash[:danger] = t "shared.error_messages.category_not_found", id: params[:id]
      redirect_to root_url
    end
  end
end
