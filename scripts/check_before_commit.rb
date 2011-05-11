#!/opt/local/bin/ruby
diff = `git diff`

errors = false
haml_diffs = /--git .*? b\/([^\n]*\.haml)\n(.*?)((\ndiff)|(\Z))/m
js_diffs = /--git .*? b\/([^\n]*\.js)\n(.*?)((\ndiff)|(\Z))/m
files_diffs = /--git .*? b\/([^\n]*\.rb)\n(.*?)((\ndiff)|(\Z))/m
trailing_comma = /(.*,(\t|\s)*$)/
wandering_puts = /(\+(\t|\s)*(p(uts|\s)|debugger).*?$)/
haml_wandering_puts = /(\+(\t|\s)*-(\t|\s)*p(uts|\s).*?$)/
js_wandering_puts = /(\+(\t|\s)*console\.log.*?$)/
xxx = /(xxx)/i

COLORS = {
  :bold  => 1,
  :red   => 31,
  :green => 32
}

def custom msg, color
  "\e[#{color}m#{msg}\e[0m"
end

COLORS.each do |color, code|
  eval "
    def #{color} msg
      custom msg, #{code}
    end
  "
end

def puts_notice msg
  puts green(msg)
end

def puts_error msg
  puts bold(red(msg))
end

def puts_ok msg
  puts bold(green(msg))
end

if !diff.empty? && files = diff.scan(files_diffs) and files.any?
  files.each do |file|
    if match = file[1].scan(wandering_puts) and match.any?
      puts_error "you've got #{match.size} puts in #{file[0]}:"
      errors = true
      match.each do |m|
        puts red(">>> ") + m[0]
      end
      puts "\n"
    end
    if match = file[1].scan(xxx) and match.any?
      puts_error "you've got #{match.size} XXX in #{file[0]}:"
      errors = true
      match.each do |m|
        puts red(">>> ") + m[0]
      end
      puts "\n"
    end
  end
end

if !diff.empty? && haml = diff.scan(haml_diffs) and haml.any?
  haml.each do |h|
    if match = h[1].scan(trailing_comma) and match.any?
      puts_error "you've got #{match.size} trailing comma(s) in #{h[0]}:"
      errors = true
      match.each do |m|
        puts red(">>> ") + m[0]
      end
      puts "\n"
    end
    if match = h[1].scan(haml_wandering_puts) and match.any?
      puts_error "you've got #{match.size} puts in #{h[0]}:"
      errors = true
      match.each do |m|
        puts red(">>> ") + m[0]
      end
      puts "\n"
    end
  end
end

if !diff.empty? && js_files = diff.scan(js_diffs) and js_files.any?
  js_files.each do |file|  
    if match = file[1].scan(js_wandering_puts) and match.any?
      puts_error "you've got #{match.size} 'console.log' in #{file[0]}:"
      errors = true
      match.each do |m|
        puts red(">>> ") + m[0]
      end
      puts "\n"
    end
  end
end


puts_ok "**** No errors, go ! ****" unless errors
puts "\n"
puts_notice "Here are the modified files: \n\n"
puts `git status`
puts "\n"
puts_notice "Here is the complete diff (READ IT YOU LAZY BASTARD): \n\n"
puts diff

#puts "> Do you want to commit these changes ? (y/N)"
#choice = gets
#if choice.chomp.downcase == 'y'
#  if errors
#    puts 'The script detected some errors, are you sure you want to commit? (y/N)'
#    choice = gets
#    return unless choice.chomp.downcase == 'y'
#  end
#  puts_ok "**** revision : #{12} ****"
#else
#  puts_ok 'See you'
#end