# rubocop:disable Style/LineLength
require 'bundler/setup'
Bundler.require
require 'yaml'
require 'active_support/core_ext'
require 'pry'
require 'pry-byebug'
require_relative 'config/library.rb'
include ActiveSupport::Inflector

create_articles

task default: :build

desc 'Build the website'
task build: %i(clean landing_page articles stylesheets minify_javascripts images report)

stylesheets = Rake::FileList['css/*.sass']
javascripts = Rake::FileList['js/*.coffee', 'js/*.js']
javascripts.exclude('js/*.min.js')
images = Rake::FileList['**/*.jpg']
all_files = Rake::FileList['**/*']

desc "Report build complete"
task :report do
  puts "Website build completed at [#{Time.now.to_s}]"
end

desc 'Process stylesheets'
task stylesheets: stylesheets.ext('css')

desc 'Process javascript'
task javascripts: javascripts.ext('js')

desc 'Minify javascript'
task minify_javascripts: javascripts.ext('min')

desc 'Create landing page / index.html'
task landing_page: 'index.html'

desc 'Proccess jpegs with jpegoptim'
task :images do
  puts 'optimizing jpegs...'
  images.each do |image|
    "jpegoptim --strip-all --quiet #{image.gsub(/ /, '\ ')}"
    # puts 'jpegoptim_output >>>>>>>>>> ' + jpegoptim_output
  end
end

puts "starting articles_yaml stuff"
articles_yaml = YAML.load_file('articles/articles.yml')
articles_yaml.keys.each_with_index do |article, index|
  file "articles/#{article}.html" => [Dir["articles/content/_#{article}_article.html*"].first, 'articles/template.html.haml', 'articles/articles.yml'] do |t|
    article_locals = articles_yaml[article]
    article_locals['folder'] = article
    # next_index = index == articles_yaml.keys.size - 1 ? 0 : index + 1
    article_locals['next_article'] = get_next_article(articles_yaml, index)
    article_locals['prev_article'] = get_prev_article(articles_yaml, index)
    article_name = article_locals['page_name'].present? ? "articles/#{article_locals['page_name']}.html" : t.name
    puts 'Adding nav buttons'.center(25) + " Writing #{article_name}"
    File.open(article_name, 'w') do |file|
      file.write Tilt.new(File.expand_path('../articles/template.html.haml', __FILE__)).render(Object.new, article_locals)
    end
  end
end

desc 'Maps the yaml data to individual article html files'
task articles: articles_yaml.keys.map { |article| "articles/#{article}.html" }

file 'index.html' => %w(index.html.erb
                        partials/_grid_layout.html.haml
                        articles/articles.yml) do |t|
  puts 'File 1'.center(25) + "Writing #{t.name}"
  File.open(t.name, 'w') do |f|
    f.write Tilt.new('index.html.erb').render
  end
end

rule '.js' => '.coffee' do |t|
  puts 'Rule 1'.center(25) + "Writing #{t.name}"
  File.open(t.name, 'w') do |f|
    f.write CoffeeScript.compile File.read(t.source)
  end
end

rule '.css' => '.sass' do |t|
  sh "sass --style compressed #{t.source} #{t.name}"
end

rule '.min' => '.js' do |t|
  puts 'Rule 2'.center(25) + "Writing #{t.name}.js"
  File.open("#{t.name}.js", 'w') do |f|
    f.write Uglifier.new(output: { comments: :none }).compile(File.read(t.source))
  end
end

desc 'Clean up previous generated versions of files before creating new ones and fix file extension issues'
task :clean do
  files_to_delete = Dir['articles/*.html']
  files_to_delete << 'index.html'
  files_to_delete << 'css/article.css'
  files_to_delete.each do |x|
    if File.exist?(x)
      File.delete(x)
      puts 'Deleting old version of ' + x
    end
  end
  all_files.each do |f|
    if File.extname(f).match(/\p{Upper}/) != nil
      puts "Making extension lowercase for file: #{f}"
      File.rename(f,  File.path(f).sub(File.basename(f), '') + File.basename(f).sub(File.extname(f), '') + File.extname(f).downcase)
    end
    if File.extname(f).downcase == '.jpeg'
      puts "Changing extension from .jpeg to jpg for file: #{f}"
      File.rename(f,  File.path(f).sub(File.basename(f), '') + File.basename(f).sub(File.extname(f), '') + '.jpg')
    end
  end
end

task :create_articles do
  create_articles
end