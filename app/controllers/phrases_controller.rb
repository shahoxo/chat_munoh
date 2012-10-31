class PhrasesController < ApplicationController
  before_filter :find_munoh
  before_filter :find_phrase, only: [:update, :destroy]

  def index
    @phrases = @munoh.phrases
  end

  def new
    @phrase = @munoh.phrases.new
  end

  def edit
    @phrase = Phrase.find(params[:id])
  end

  def create
    @phrase = @munoh.phrases.new(params[:phrase])
    if @phrase.save
      redirect_to munoh_phrases_url
    else
      render :new
    end
  end

  def update
    if @phrase.update_attributes(params[:phrase])
      redirect_to munoh_phrases_url
    else
      render :edit
    end
  end

  def destroy
    @phrase.destroy
    redirect_to munoh_phrases_url
  end

  private
  def find_munoh
    @munoh = Munoh.find_by_id(params[:munoh_id])
    unless @munoh
      redirect_to munohs_url
      return false
    end
  end

  def find_phrase
    @phrase = @munoh.phrases.find(params[:id])
  end
end
