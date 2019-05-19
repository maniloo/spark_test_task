class Spree::Admin::ProductsImportsController < Spree::Admin::BaseController
  def new; end

  def create
    if incorrect_file_send
      flash[:error] = "File not sended or type is inncorrect"

      redirect_to action: :new and return
    end

    file_path = "tmp/#{SecureRandom.urlsafe_base64}.csv"
    File.write(file_path, params[:csv_file].read)

    ImportProductsJob.perform_later(file_path)
    flash[:success] = "Background import runned successfully"

    redirect_to admin_products_path
  end

  private

  def incorrect_file_send
    params[:csv_file].nil? || params[:csv_file].path.split(//).last(3).join != "csv"
  end
end
