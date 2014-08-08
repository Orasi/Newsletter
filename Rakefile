require 'coffee-script'
require 'haml'
require 'uglifier'
require 'yaml'

task :default => :build
task :build => [:landing_page, :articles, :stylesheets, :javascripts, :images]

stylesheets = Rake::FileList['css/*.sass']
javascripts = Rake::FileList['js/*.coffee']
images = Rake::FileList['**/*.jpg']
task :stylesheets => stylesheets.ext('css')
task :javascripts => javascripts.ext('js')
task :landing_page => 'index.html'

task :images do
  images.each do |image|
    sh "jpegoptim --strip-all --quiet #{image.gsub(/ /, '\ ')}"
  end
end

articles_yaml = YAML.load_file('articles/articles.yml')
articles_yaml.keys.each do |article|
  file "articles/#{article}.html" => ["articles/content/_#{article}_article.html.haml", 'articles/template.html.haml', 'articles/articles.yml'] do |t|
    article_locals = articles_yaml[article]
    puts "Writing #{t.name}"
    File.open(t.name, 'w') do |file|
      file.write Haml::Engine.new(File.read(File.expand_path('../articles/template.html.haml', __FILE__))).render(Object.new,article_locals)
    end
  end
end


task :articles => articles_yaml.keys.map {|article| "articles/#{article}.html"}

file 'index.html' => ['index.html.erb', 'partials/_grid_layout.html.haml'] do |t|
  ruby 'bin/update_index'
end

rule ".js" => ".coffee" do |t|
  File.open(t.name, 'w') do |f|
    f.write Uglifier.new.compile(CoffeeScript.compile File.read(t.source))
  end
end

rule ".css" => ".sass" do |t|
  sh "sass --style compressed #{t.source} #{t.name}"
end

