class Site < ActiveRecord::Base
  default_scope { order('title ASC') }
  has_many :fiddles  
  
  def refresh
    # remove current fiddles from the database
    Fiddle.where( :site_id => self.id ).each { |f| f.destroy }
    # inject all files again
    fx = Dir.glob("#{self.file_path}/**/*").reject { |file_path| File.directory? file_path }   
    fx.each do |fn|
      Fiddle.load_from fn, self
    end        
 end 
 
  
end
