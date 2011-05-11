require 'date'
require 'yaml'

RAILS_ROOT = '/Users/zog/Projects/ls-server'
class Array; def sum; inject( nil ) { |sum,x| sum ? sum+x : x }; end; end

today = Date.today
results = {today => {:code => {}, :tests => {}}}

lines_cmd = "wc -l `find #{RAILS_ROOT} -name '*.%s'`"
  
%w(rb yml sass js haml).each do |ext|
  lines = `#{lines_cmd % ext}`
  results[today][:code][:"#{ext}_lines"] = lines.match(/.*?(\d+)? total/m)[1].to_i rescue 0
end

results[today][:code][:total] = results[today][:code].values.sum

tests_lines_cmd = "wc -l `find #{RAILS_ROOT}/test -name '*.*'`"
lines = `#{tests_lines_cmd}`
results[today][:tests][:lines] = lines.match(/.*?(\d+)? total/m)[1].to_i rescue 0
results[today][:tests][:ratio] = (results[today][:tests][:lines].to_f / results[today][:code][:total] * 10000).to_i.to_f / 100
puts results.to_yaml