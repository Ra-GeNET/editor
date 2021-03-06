class SitesController < ApplicationController
  http_basic_authenticate_with name: "rara", password: "shift123!@#"
  before_action :set_site, only: [:show, :edit, :update, :destroy, :refresh]

  # GET /sites/1/refresh
  # GET /sites/1/refresh.json
  def refresh
    @site.refresh
    redirect_to @site
  end

  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.all
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    result = Fiddle.tree( @site.fiddles.where( :noindex => false, :deleted_at => nil ).order('file_path COLLATE NOCASE') )
    result = result.sort_by { |k,v| k }
    @tree = Hash[*result.flatten]
    render :show, :layout => false
  end
  
  # GET /sites/1/all
  # GET /sites/1/all.json
  def all
    @tree = Fiddle.tree( @site.fiddles.where( :deleted_at => nil ) )
    render :show, :layout => false
  end

  # GET /sites/1/trash
  # GET /sites/1/trash.json
  def trash
    @tree = Fiddle.tree( @site.fiddles.where( "deleted_at IS NOT NULL" ) )
    render :show, :layout => false
  end

  # GET /sites/new
  def new
    @site = Site.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:file_path, :title, :automap)
    end
end
