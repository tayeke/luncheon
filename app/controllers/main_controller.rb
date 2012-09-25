class MainController < ApplicationController
  def index
    @lunch = Lunch.new
  end
end
