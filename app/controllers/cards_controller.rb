class CardsController < ApplicationController
  before_action :set_card, only: %i[ show edit update destroy move]

  def index
    @cards = Card.all
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        ActionCable.server.broadcast "board", { commit: 'addCard', payload: render_to_string(:show, formats: [:json]) }
        format.json { render :show, status: :created, location: @card }
      else
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        ActionCable.server.broadcast "board", { commit: 'editCard', payload: render_to_string(:show, formats: [:json]) }
        format.json { render :show, status: :ok, location: @card }
      else
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def move
  @card.update(card_params)
    render action: :show
  end

  private
    def set_card
      @card = Card.find(params[:id])
    end

    def card_params
      params.require(:card).permit(:list_id, :name, :position)
    end
end
