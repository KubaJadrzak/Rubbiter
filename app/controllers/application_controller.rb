class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def render_flash
    render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
  end

  private

  def handle_record_not_found(exception)
    redirect_to root_path, alert: "The resource you were looking for was not found."
  end
end
