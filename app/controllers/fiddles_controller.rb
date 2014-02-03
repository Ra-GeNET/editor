class FiddlesController < ApplicationController
  before_action :set_fiddle, only: [:show, :preview, :edit, :update, :destroy]
  before_action :set_help
  layout false

  def start
    redirect_to fiddles_url
  end

  # GET /fiddles
  # GET /fiddles.json
  def index
    @tree = { 'Sites' => {} }
    Site.all.each do |s|
      @tree['Sites'][s.file_path] = [s]
    end
    result = Fiddle.tree( Fiddle.where( :noindex => false, :deleted_at => nil ).where("file_path is NULL").order('title ASC') )
    result = result.sort_by { |k,v| k }
    result = Hash[*result.flatten]
    @tree = @tree.merge result
  end  
  
  # GET /fiddles/hidden
  # GET /fiddles/hidden.json
  def hidden
    @tree = Fiddle.tree( Fiddle.where( :noindex => true, :deleted_at => nil ).where("file_path is NULL") )
    render :index
  end
  
  # GET /fiddles/thrash
  # GET /fiddles/thrash.json
  def trash
    @tree = Fiddle.tree( Fiddle.where( :noindex => false ).where( "deleted_at IS NOT NULL AND file_path is NULL") )
    render :index
  end
  
  # GET /fiddles/all
  # GET /fiddles/all.json
  def all
    @tree = Fiddle.tree( Fiddle.all )
    render :index
  end



  # GET /fiddles/1
  # GET /fiddles/1.json
  def show
    respond_to do |format|
      l = @fiddle.lang.title
      if l == "Markdown" then
        format.html { render :markdown }
      elsif l == "Textile" then
        format.html { render :textile }
      elsif l == "Less" then
        format.html { render :less }
      elsif l == "Scss" then
        format.html { render :scss }
      else
        format.html { render :text => @fiddle.code, :content_type => @fiddle.lang.content_type }
      end
      format.json 
    end
  end
  
  # GET /fiddles/1/preview
  # GET /fiddles/1.json
  def preview
    if @fiddle.lang == "markdown" then
      render :markdown
    elsif @fiddle.lang == "textile" then
      render :textile
    elsif @fiddle.lang == "less" then
      render :less
    elsif @fiddle.lang == "scss" then
      render :scss
    else
      render :text => @fiddle.code, :content_type => @fiddle.lang.content_type
    end
  end


  # GET /fiddles/1/edit
  def edit
  end

  # POST /fiddles
  # POST /fiddles.json
  def create
    @fiddle = Fiddle.new(fiddle_params)

    respond_to do |format|
      if @fiddle.save
        format.html { redirect_to @fiddle, notice: 'Fiddle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @fiddle }
      else
        format.html { render action: 'new' }
        format.json { render json: @fiddle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fiddles/1
  # PATCH/PUT /fiddles/1.json
  def update
    @fiddle.touch
    respond_to do |format|
      if @fiddle.update(fiddle_params)
        @fiddle.write_to_disk
        format.html { render :show }
        format.json { render json: { :updated_at => @fiddle.updated_at } }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fiddle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fiddles/1
  # DELETE /fiddles/1.json
  def destroy
    @fiddle.destroy
    respond_to do |format|
      format.html { redirect_to fiddles_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fiddle
      @fiddle = Fiddle.find(params[:id])
      @fiddle.refresh
    end
    
    def set_help
      @help = Fiddle.where(:title => "Help").first
      unless @help then
        @help = Fiddle.create :title => "Help", :code => "Dit is de help file", :langcode => "markdown", :skin => "chaos", :lineheight => "24px", :fontsize => "16px"        
      end      
    end    

    # Never trust parameters from the scary internet, only allow the white list through.
    def fiddle_params
      params.require(:fiddle).permit(:title, :code, :langcode, :skin, :fontsize, :lineheight, :noindex, :deleted_at, :preview_url, :category)
    end

end
