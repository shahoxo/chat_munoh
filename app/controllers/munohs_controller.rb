class MunohsController < ApplicationController
  before_filter :find_munoh, only: [:edit, :update, :destroy]

  def index
    @munohs = Munoh.all
  end

  def new
    @munoh = Munoh.new
  end

  def create
    @munoh = Munoh.new(params[:munoh])
    if @munoh.save
      redirect_to munohs_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @munoh.update_attributes(params[:munoh])
      redirect_to munohs_url
    else
      render :edit
    end
  end

  def destroy
    @munoh.destroy
    redirect_to munohs_url
  end

  private
  def find_munoh
    @munoh = Munoh.find(params[:id])
  end  
end
