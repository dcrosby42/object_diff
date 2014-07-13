PROJ_ROOT = File.expand_path(File.dirname(__FILE__) + "/..") 
$LOAD_PATH << "#{PROJ_ROOT}/lib"

require 'bundler'
Bundler.setup

require 'difference'

