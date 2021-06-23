class ListsController < ApplicationController
  before_action :set_list, only: %i[ show edit update destroy move]

  def index
    @lists = List.sorted
  end

  def show
  end

  def new
    @list = List.new
  end

  def edit
  end

  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        ActionCable.server.broadcast "board", { commit: 'addList', payload: render_to_string(:show, formats: [:json]) }
        format.json { render :show, status: :created, location: @list }
      else
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.json { render :show, status: :ok, location: @list }
      else
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def move
    @list.insert_at(list_params[:position].to_i)
    render action: :show
  end

  private
    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:name, :position)
    end
end
