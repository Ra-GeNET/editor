class Site < ActiveRecord::Base
  default_scope { order('title ASC') }
  has_many :fiddles  
  
  def refresh
    fx = Dir.glob("#{self.file_path}/**/*").reject { |file_path| File.directory? file_path }   
    fx.each do |fn|
      Fiddle.load_from fn, self
    end        
 end 
 
  
end
