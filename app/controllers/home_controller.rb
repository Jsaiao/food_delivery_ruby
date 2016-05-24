class HomeController < ApplicationController
  # GET /
  def index
    @logbook = policy_scope(Logbook).paginate(page: params[:page], per_page: 15).order('id DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end
end
