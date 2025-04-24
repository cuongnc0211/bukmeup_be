class Api::BaseController < ActionController::API
  # Rescue common exceptions
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from StandardError, with: :standard_error
  rescue_from UnauthorizedError, with: :unauthorized_error

  private

  def record_not_found(error)
    render json: { error: 'Record not found' }, status: :not_found
  end

  def record_invalid(error)
    render json: { error: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def parameter_missing(error)
    render json: { error: "Required parameter missing: #{error.param}" }, status: :bad_request
  end

  def standard_error(error)
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def unauthorized_error(error)
    render json: { error: error.message.presence || "Unauthorized: Token is invalid" }, status: :unauthorized
  end
end
