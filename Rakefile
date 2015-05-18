# rubocop:disable Style/LineLength
require 'bundler/setup'
Bundler.require
require 'yaml'
require 'active_support/core_ext'
require 'kramdown'
require 'html2haml'
require 'pry'
require 'pry-byebug'
# binding.pry

include ActiveSupport::Inflector

task default: :build

desc 'Build the website'
task build: %i(create_articles clean landing_page articles stylesheets minify_javascripts images report)

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

def read_file(file)
  f = File.open(file, 'r')
  data = f.read
  f.close
  data
end

def secret_title
  (0..25).map { [*0..9,*'a'..'z',*'A'..'Z',].sample }.join
end

def create_articles
=begin
  This definition does a few things:
  1. Updates the article.yml file based on what's in article_list.txt
  2. Creates a haml file for each article in article.yml
  3. Imports content from the markdown folder into the haml files
  NOTE: this script does not delete any haml files that already exist. You will have to manually delete them if you want to start from scratch, or comment them from the article_list.txt
=end

  # puts "What do you want to do?\n\n1. Process the article_list file for new content\n2. Rebuild the website with the current content/edits\n\nPlease type 1 or 2 and press enter to continue."
  # return if gets.chomp == 2.to_s

  articles_file = 'articles/articles.yml'
  event_format = ".card\n  .header-image{style: \"background-image: url('../img/ARTICLE_IMAGE_FOLDER/IMAGE_NAME.jpg');\"}\n  .details\n    %h3 EVENT_TITLE - EVENT_TIME\n    %span\n      EVENT_DESCRIPTION\n      %p\n        %a{href: 'EVENT_URL'} EVEN_URL_DESCRIPTION"
  # event_format = "STUPID EVENT FORMAT ISSUES"

  # archive existing article.yml
  if File.exist?(articles_file)
    renamed = "archived/articles_#{Time.now.strftime('%Y%m%d_%H%M%S')}.yml"
    puts "\n----\nRenaming #{articles_file} to #{renamed} and moving it to 'archived'\n----"
    File.rename(articles_file, renamed)
  end

  File.open(articles_file, 'w'){ |f| }

  # create resources for each new article
  # update this to read an excel file or csv?
  contents = File.readlines('article_list')
  articles = Array.new
  contents.each do |l|
    # skip articles that are commented out
    next if l[0] == '#'

    # get attributes
    l.chomp!
    attributes = l.strip.split("|||")
    title, author, no_gallery, hidden, page_name = attributes

    # create filename based on the the title or page_name
    if page_name.nil?
      filename = title.downcase.gsub(/[^0-9a-z]+/, '_')
    elsif page_name == 'secret_guess_who_information'
      page_name = secret_title
      filename = page_name
    else
      filename = page_name.downcase.gsub(/[^0-9a-z]+/, '_')
    end
    full_filename = "_#{filename}_article.html.haml"
    articles << full_filename

    # add the article data to articles.yml
    article_data = "#{filename}:\n  title: #{title.gsub(':', ' -')}"
    article_data += "\n  author: #{author}" unless author.nil? || author.empty?
    article_data += "\n  no_gallery: true" unless no_gallery.nil?
    article_data += "\n  hidden: true" unless hidden.nil?
    article_data += "\n  page_name: #{page_name}" unless page_name.nil?
    open(articles_file, 'a') { |f| f.puts article_data }

    # create the haml content file
    open("articles/content/#{full_filename}", 'a') do |f|

      # add content placeholders for empty files
      if File.zero?(f)
        puts "Created article file: #{full_filename}"
        markdown_file = "articles/markdown/#{title}.md"
        if File.exist?(markdown_file)
          markdown = File.read(markdown_file)
          kramdown = Kramdown::Document.new(markdown).to_html
          haml = Html2haml::HTML.new(kramdown).render
          f.puts haml
        elsif filename.include?('event')
          f.puts "//-----USE THE FORMAT BELOW TO CREATE EACH EVENT ITEM-----"
          f.puts event_format
        else
          f.puts "%p.article-text\n\n\t.small-image.c\n\t\t%img{src: '../img/IMAGE_FOLDER/IMAGE_NAME.jpg'}"
        end
      else
        puts "Article file: #{full_filename} already has content - no changes made."
      end
    end

    # create an img directory for the article
    unless Dir.exist?("img/#{filename}")
      system("mkdir img/#{filename}")
    end
  end

  # add the birthdays article
  open(articles_file, 'a') { |f| f.puts "birthdays_anniversaries:\n  title: Birthdays and Anniversaries\n  no_gallery: true" }

  # archive any article content files that weren't in the list, except for the birthdays article
  # if the birthdays haml file gets manually deleted, you'll need to recreate it from the git source or rake won't work
  puts "\n----\nArchiving unlisted article resources\n----"
  Dir.mkdir('archived') unless Dir.exist?('archived')
  Dir.glob('articles/content/*.haml').each do |f|
    unless articles.include?(File.basename(f)) || File.basename(f) == '_birthdays_anniversaries_article.html.haml'
      puts "File [#{File.basename(f)}] isn't in the article list, so it is being archived."
      File.rename(f, "archived/#{File.basename(f)}")
    end
  end

  # archive any image folders for articles that weren't in the list, except the avatars folder
  Dir.mkdir('archived/img') unless Dir.exist?('archived/img')
  Dir.glob('img/*/').each do |d|
    img_folder = File.basename(d)
    unless articles.include?("_#{img_folder}_article.html.haml") || File.basename(d) == 'avatars' || File.basename(d) == 'birthdays_anniversaries'
      puts "Folder img/#{img_folder} isn't associated with an article in the article list, so it is being archived."
      system("mv img/#{img_folder} archived/img/#{img_folder}")
    end
  end

  puts "\n----\nDone creating/updating article structure. Ready for content!\n----\n"
end

def get_next_article(articles_yaml, index)
  next_index = index == articles_yaml.keys.size - 1 ? 0 : index + 1
  return articles_yaml.keys[next_index] unless articles_yaml[articles_yaml.keys[next_index]]['hidden'] == true
  get_next_article(articles_yaml, next_index)
end

def get_prev_article(articles_yaml, index)
  prev_index = index == 0 ? articles_yaml.keys.size - 1 : index - 1
  return articles_yaml.keys[prev_index] unless articles_yaml[articles_yaml.keys[prev_index]]['hidden'] == true
  get_prev_article(articles_yaml, prev_index)
end

def get_avatar(name)
  Dir['img/avatars/*.jpg'].each do |image_file|
    return image_file if File.basename(image_file, '.jpg') == name
  end
  Kernel.puts "Could not find matching avatar for [#{name}]"
  File.path('/img/avatars/placeholder.jpg')
end

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