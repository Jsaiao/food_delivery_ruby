class HomeController < ApplicationController
  # GET /
  def index
    @logbook = Logbook.all.paginate(page: params[:page], per_page: 15).order('id DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end
end
