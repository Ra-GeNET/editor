class Extmap < ActiveRecord::Base
  default_scope { order("priority DESC, category DESC, suffix DESC") }
  before_save :set_defaults
  belongs_to :lang

  def self.suggest( ff )
    fn = ff.file_path
    ff.category = nil
    ff.lang = nil

    ne = false
    result = Extmap.order("priority DESC, category DESC, suffix DESC").all.reject do |r|
      !r.verexp.match( fn )
    end
    if result.count > 0 then
      result.each do |r|
        ff.noindex  ||= r.noindex
        ff.lang     ||= r.lang
        ff.category ||= r.category
        ne          ||= r.noedit
      end          
    end    
    unless ff.lang then
      ff.lang = Lang.where( :content_type => `file -b --mime-type #{fn}`.strip ).first    
    end
    if ff.lang then
      ff.langcode = ff.lang.code
    end
    return ( !ne && ff.lang ) ? ff : false
  end
  
  def verexp
    VerEx.new do
      skip = false
      self.suffix.split('%').each do |s|
        if s == "" then          
          skip = true
        elsif skip then 
          find s
        else
          start_of_line
          find s
        end
      end      
      end_of_line unless self.suffix.end_with?('%')       
    end
  end
  
private

  def set_defaults
    self.category = nil if self.category && self.category.strip == "" 
    self.suffix = nil if self.suffix && self.suffix.strip == ""
    self.suffix = self.suffix.strip.downcase if self.suffix    

    sx = self.suffix
    if self.noedit then
      self.priority = 100
    elsif sx.start_with?("%") && sx.end_with?("%") then
      self.priority = 5
    elsif sx.start_with?("%") then
      self.priority = 10
    elsif sx.end_with?("%") then
      self.priority = 25
    elsif sx.include?("%") then
      self.priority = 50
    else
      self.priority = 90
    end
  end  
  
end
