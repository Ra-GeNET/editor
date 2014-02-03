class ExtmapsController < ApplicationController
  before_action :set_extmap, only: [:show, :edit, :update, :destroy]

  # GET /extmaps
  # GET /extmaps.json
  def index
    @extmaps = Extmap.all
  end

  # GET /extmaps/1
  # GET /extmaps/1.json
  def show
  end

  # GET /extmaps/new
  def new
    @extmap = Extmap.new
  end

  # GET /extmaps/1/edit
  def edit
  end

  # POST /extmaps
  # POST /extmaps.json
  def create
    @extmap = Extmap.new(extmap_params)

    respond_to do |format|
      if @extmap.save
        format.html { redirect_to extmaps_url, notice: 'Extmap was successfully created.' }
        format.json { render action: 'show', status: :created, location: @extmap }
      else
        format.html { render action: 'new' }
        format.json { render json: @extmap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /extmaps/1
  # PATCH/PUT /extmaps/1.json
  def update
    respond_to do |format|
      if @extmap.update(extmap_params)
        format.html { redirect_to extmaps_url, notice: 'Extmap was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @extmap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /extmaps/1
  # DELETE /extmaps/1.json
  def destroy
    @extmap.destroy
    respond_to do |format|
      format.html { redirect_to extmaps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extmap
      @extmap = Extmap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def extmap_params
      params.require(:extmap).permit(:suffix, :noindex, :noedit, :category, :lang_id)
    end
end
