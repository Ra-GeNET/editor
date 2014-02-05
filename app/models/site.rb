class Site < ActiveRecord::Base
  default_scope { order('title ASC') }
  has_many :fiddles  
  
  def refresh
    # inject all files again
    fx = Dir.glob("#{self.file_path}/**/*").reject { |file_path| File.directory? file_path }   
    fx.each do |fn|
      Fiddle.load_from fn, self
    end        

    # remove current fiddles from the database
    Fiddle.where( :site_id => self.id ).each do |f|
      unless fx.include?( self.file_path + f.file_path )  then
        f.destroy
      end
    end
   
 end 
 
  
end
