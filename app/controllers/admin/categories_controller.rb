module Admin
  class CategoriesController < AdminController
    before_action :load_category, except: %i(index new create)
    before_action :load_categories, except: %i(index show destroy)
    before_action :load_tours, only: :show

    def index
      @roots = Category.roots
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new category_params
      if @category.save
        redirect_to admin_categories_url
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @category.update_attributes category_params
        flash[:success] = t "shared.success_messages.changes_saved"
        redirect_to admin_categories_url
      else
        render :edit
      end
    end

    def destroy
      if @category.destroy
        flash[:success] = t "shared.success_messages.category_deleted"
      else
        flash[:danger] = t "shared.error_messages.can_not_delete_category",
          id: params[:id]
      end
      redirect_to admin_categories_url
    end

    private

    def load_category
      return if (@category = Category.find_by id: params[:id])
      flash[:danger] = t "shared.error_messages.category_not_found", id: params[:id]
      redirect_to admin_categories_url
    end

    def load_categories
      @categories =
        if @category
          Category.all_but_self_and_descendants @category
        else
          Category.all
        end
    end

    def load_tours
      categories = @category.self_and_descendants.map(&:id).join(",")
      @tours = Tour.under_these_categories(categories).order_by_created_at
        .page(params[:page]).per Settings.per_page.tour
    end

    def category_params
      params.require(:category).permit :name, :parent_id
    end
  end
end
