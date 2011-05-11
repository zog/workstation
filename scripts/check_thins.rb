#!/usr/bin/env ruby

error = 0
ARGV.each do |port|
  res = `ps aux|grep 'thin server' | grep ':#{port}'`
  if res == ""
    error += 1
    print "Error: no server on port #{port}\n"
  end
end

exit error
