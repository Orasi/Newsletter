articles_file = 'articles/articles.yml'
event_format = ".card\n  .header-image{style: 'background-image: url('../img/ARTICLE_IMAGE_FOLDER/IMAGE_NAME.jpg');'}\n  .details\n    %h3 EVENT_TITLE - EVENT_TIME\n    %span\n      EVENT_DESCRIPTION\n      %p\n        %a{href: 'EVENT_URL'} EVEN_URL_DESCRIPTION"

# archive existing article.yml
if File.exist?(articles_file)
  renamed = "archived/articles_#{Time.now.strftime('%Y%m%d_%H%M%S')}.yml"
  puts "\n----\nRenaming #{articles_file} to #{renamed} and moving it to 'archived'\n----"
  File.rename(articles_file, renamed)
end

# create resources for each new article
articles = Array.new
File.readlines('article_list').each do |l|
  title, author = l.strip.split("\t")
  filename = title.downcase.gsub(/[^0-9a-z]+/, '_')
  full_filename = "_#{filename}_article.html.haml"
  articles << full_filename
  article_data = "#{filename}:\n  title: #{title.gsub(':', ' -')}\n  author: #{author}\n  no_gallery: false"

  # add the article data to articles.yml
  open(articles_file, 'a') { |f| f.puts article_data }

  # create the content file
  open("articles/content/#{full_filename}", 'a') do |f|
    puts "Created/appended article file: #{full_filename}"

    #add template for events article
    if filename.include?('event') && File.zero?(f)
      f.puts "-----USE THE FORMAT BELOW TO CREATE EACH EVENT ITEM-----"
      f.puts event_format
    end
  end

  # create an img directory for the article
  unless Dir.exist?("img/#{filename}")
    system(mkdir_p "img/#{filename}")
  end



end

# add the birthdays article
open(articles_file, 'a') { |f| f.puts "birthdays_anniversaries:\n  title: Birthdays and Anniversaries\n  no_gallery: true" }

# archive any article content files that weren't in the list, except for the birthdays artcile
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
    system("mv img/#{img_folder}, archived/img/#{img_folder}")
  end
end

puts "\n----\nDone creating/updating article structure. Ready for content!\n----\n"
