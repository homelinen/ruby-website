require "sinatra"

require "haml"
require "yaml"
require "redcarpet"

require "sass"
require "bourbon"
require "neat"

set :markdown, :layout_engine => :haml, :layout => :layout
set :haml, :format => :html5

# ROUTES
get '/' do
    @articles = Dir['content/*.md'].sort.reverse
    haml :index
end

get '/css/main.css' do
   sass :main, :style => :expanded 
end

def parse_article(filename)
    file = File.new(filename)
    yaml = YAML.load(file)
    c = 0
    file.rewind
    minus_front = file.readlines.select do |l| 
        if l.strip == '---'
            c += 1
            false
        elsif c > 1
            true
        end
    end
    minus_front
end

