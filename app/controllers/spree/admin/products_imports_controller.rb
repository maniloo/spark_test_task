class Spree::Admin::ProductsImportsController < Spree::Admin::BaseController
  def new; end

  def create
    if csv_products_importer.call
      flash[:success] = "#{csv_products_importer.successfully_imported} products imported"
      redirect_to admin_products_path
    else
      flash[:error] = "Something went wrong"
      redirect_to action: :new
    end
  end

  private

  def csv_products_importer
    @csv_products_importer ||= CSVProductsImporter.new(
      file: params[:csv_file]
    )
  end
end
