class MainController < ApplicationController
  def index
    @lunch = Lunch.new
    clearOldLunches()
  end
end
