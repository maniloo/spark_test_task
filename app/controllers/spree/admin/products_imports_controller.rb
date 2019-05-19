class Spree::Admin::ProductsImportsController < Spree::Admin::BaseController
  def new; end

  def create
    file_path = "tmp/#{SecureRandom.urlsafe_base64}.csv"
    File.write(file_path, params[:csv_file].read)

    ImportProductsJob.perform_later(file_path)
    flash[:success] = "Background import runned successfully"

    redirect_to admin_products_path
  end
end
