class PagesController < ApplicationController
  allow_unauthenticated_access only: :home
  layout "landing", only: :home

  def home
  end
end
