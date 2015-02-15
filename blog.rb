require "sinatra"

# Layout
require "haml"
require "yaml"
require "rdiscount"

# CSS
require "sass"
require "bourbon"
require "neat"

require "date"
require "ordinal"

set :markdown, :layout_engine => :haml, :layout => :article
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
    match = /\d{4}-\d{2}-\d{2}/.match(filename)
    
    if match

        file = File.new(filename)
        yaml = YAML.load(file)

        date = Date.parse(match[0])
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
        {
            content: minus_front,
            date: date
        }
    end
end

