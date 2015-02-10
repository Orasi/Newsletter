articles_file = 'articles/articles.yml'

# archive any existing files
if File.exist?(articles_file)
  renamed = "articles/archived/articles_#{Time.now.strftime('%Y%m%d_%H%M%S')}.yml"
  puts "\n----\nRenaming #{articles_file} to #{renamed} and moving it to 'articles/archived'\n----"
  File.rename(articles_file, renamed)
end

# create new files
articles = Array.new
File.readlines('article_list').each do |l|
  title, author = l.strip.split("\t")
  filename = title.downcase.gsub(/[^0-9a-z]+/, '_')
  full_filename = "_#{filename}_article.html.haml"
  articles << full_filename
  article_data = "#{filename}:\n  title: #{title}\n  author: #{author}"
  open(articles_file, 'a') { |f| f.puts article_data }
  open("articles/content/#{full_filename}", 'a') do |f|
    puts "Created/appended article file: #{full_filename}"
    # f.puts "%p.article-text\n\tPlaceholder text"
  end
end

# archive any files that weren't in the list
puts "\n----\nArchiving unlisted article.haml files\n----"
article_files = Dir.glob('articles/content/*.haml')
article_files.each do |f|
  unless articles.include?(File.basename(f))
    puts "File [#{File.basename(f)}] isn't in the article list, so its being archived."
    File.rename(f, "articles/archived/#{File.basename(f)}") 
  end
end
