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

get '/post/:date/:name' do
    date = params[:date]
    name = params[:name]

    post_name = "content/#{date}-#{name}.md"
    @articles = Dir['content/*.md']
    if @articles.include? post_name
        post = parse_article(post_name)
        @date = post[:date]
        @title = post[:title]
        haml :layout, layout: false do 
            markdown post[:content].join("")
        end
    else
        status 404
        haml "%h1 404"
    end

end

def parse_article(filename)
    match = /(\d{4}-\d{2}-\d{2})-([\w\d\-_]+)/.match(filename)
    
    if match

        file = File.new(filename)
        yaml = YAML.load(file)

        date = Date.parse(match[1])
        title = match[2]
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
            date: date,
            title: title
        }
    end
end

