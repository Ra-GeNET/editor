class Fiddle < ActiveRecord::Base
  before_save :set_lang, :set_category, :set_title, :set_file_path, :set_noindex
  belongs_to :site
  belongs_to :lang
  
  def self.tree( s )
    result = {}
    s.each do |f|
      k1 = f.category
      k2 = f.folder || "Fiddles"
      result[ k1 ] ||= {}
      result[ k1 ][ k2 ] ||= []
      result[k1][k2] << f
    end
    return result
  end  
  
  def self.load_from( fn, s )
    fn = File.expand_path( fn, s.file_path )
    fn = nil unless fn.start_with?( s.file_path )    
    
    if fn then
      
      ff = Fiddle.where( :file_path => fn.gsub( s.file_path,''), :site => s ).first
      unless ff then
        ff = Fiddle.new :file_path => fn, :code => "", :skin => "ambiance", :lineheight => "24px", :fontsize => "16px", :site => s
        ff.set_file_path
      end      
      ff = Extmap.suggest( ff, s.automap )                      
      ff.load_from_disk true if ff
            
    end    
    
  end
  
  def load_from_disk( forceLoad )
    if self.file_path then
      fp = self.site.file_path + self.file_path
      if forceLoad || (File.mtime( fp ).to_i > self.updated_at.to_i) then      
        File.open( fp, "rb" ) { |f| self.code = f.read; self.save! }
      end
    end
  end
  
  def refresh
    self.preview_url ||= "/fiddles/#{self.id}/preview"
    load_from_disk false
  end  
  
  def write_to_disk  
    if self.file_path then
      fn = self.site.file_path + self.file_path
      unless File.directory?( File.dirname( fn ) ) then
        FileUtils.mkdir_p( File.dirname( fn ) )
      end
      File.open( fn, 'w') { |f| f.write( self.code ) }
    end
    return true
  end
  
  def set_file_path
    if self.file_path then
      self.file_path = File.expand_path(self.site.file_path + self.file_path, self.site.file_path)
      self.file_path = nil unless self.file_path.start_with?(self.site.file_path)
      self.folder = File.dirname( self.file_path ).gsub( self.site.file_path, '' )
      self.file_path = self.file_path.gsub( self.site.file_path, '' )
    end
    return true
  end


private

  def set_title
    self.title ||= self.file_path ? File.basename( self.file_path ) : '(Onbekend)'
    return true
  end
  
  def set_noindex
    self.noindex ||= false
    return true
  end
  
  def set_lang
    self.lang = Lang.where( :code => self.langcode ).first
    self.lang ||= Lang.where( :id => self.langcode.to_i ).first
    unless self.lang
      self.langcode = "text"
      self.lang = Lang.where( :code => "text" ).first
    end
    return true
  end
  
  
  def set_category
    self.category = self.category.strip if self.category
    self.category = nil if self.category == ""
    unless self.category then
      self.category = self.lang.category || "Other"
    end
    return true
  end
  
end
