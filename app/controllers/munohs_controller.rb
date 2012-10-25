class MunohsController < ApplicationController
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
    @munoh = Munoh.find(params[:id])
  end

  def show
    
  end

  def update
    @munoh = Munoh.find(params[:id])
    if @munoh.update_attributes(params[:munoh])
      redirect_to munohs_url
    else
      render :edit
    end
  end

  def destroy
    @munoh = Munoh.find(params[:id])
    @munoh.destroy

    redirect_to munohs_url
  end
end
