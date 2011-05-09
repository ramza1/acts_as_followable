%w( acts_as_followable/version
    acts_as_followable/lib
    acts_as_followable/followable
    acts_as_followable/railtie
).each do |lib|
    require File.join(File.dirname(__FILE__), lib)  
end