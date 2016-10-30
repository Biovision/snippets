class Api::IllustrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :restrict_access

  # post /api/illustrations
  def create
    @illustration = Illustration.new creation_parameters
    if @illustration.save
      render :show
    else
      render json: { errors: @illustration.errors }, status: :bad_request
    end
  end

  # delete /api/illustrations/:id
  def destroy
    illustration = Illustration.find params[:id]
    illustration.destroy
    render json: 'ok'
  end

  protected

  def restrict_access
    require_role :chief_editor, :editor
  end

  def creation_parameters
    params.require(:illustration).permit(Illustration.entity_parameters).merge(owner_for_entity)
  end
end
