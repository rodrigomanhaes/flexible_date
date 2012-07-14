%w(base version).each do |filename|
  require File.join(File.dirname(__FILE__), 'flexible_date', filename)
end
