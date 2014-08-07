require 'coffee-script'
require 'uglifier'

task :default => :build
task :build => [:landing_page, :articles, :stylesheets, :javascripts, :images]

articles = Rake::FileList['articles/*.html.haml']
stylesheets = Rake::FileList['css/*.sass']
javascripts = Rake::FileList['js/*.coffee']
images = Rake::FileList['**/*.jpg']
articles.exclude('articles/template.html.haml')
task :stylesheets => stylesheets.ext('css')
task :javascripts => javascripts.ext('js')
task :landing_page => 'index.html'

task :images do
  images.each do |image|
    sh "jpegoptim --strip-all --quiet #{image.gsub(/ /, '\ ')}"
  end
end

articles.each do |article|
  file article.ext('') => [article, "articles/content/_#{File.basename(article.ext('').ext(''))}_article.html.haml", 'articles/template.html.haml'] do |t|
    sh "haml #{t.source} #{t.name}"
  end
end

task :articles => articles.ext('')

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

