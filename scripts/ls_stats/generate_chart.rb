require 'rubygems'
require 'gchart'
require 'yaml'

data = open('tracking_stats_ls.yml').read
data.gsub!(/\n---\s*\n/m, "\n")
data = YAML::load(data).sort
code = data.map{|h| h[1][:code][:total]}
test = data.map{|h| h[1][:tests][:lines]}
#p data
#sp data.map{|h| h[1][:code][:total]}

puts Gchart.line(:size => '800x300', 
            :title => "Code lines evolution",
            :bg => 'efefef',
            :line_colors => "FF0000,00FF00,0000FF",
            :legend => ['Total lines count', 'Test lines count'],
            :axis_with_labels => ['x', 'y', 'r'],
            :axis_labels => [data.map{|k| k[0].strftime "%d/%m"}.join("|")],
            :data => [code.map{|v| v - code.min}, test.map{|v| v - test.min}]#,
            #:max_value => code.max + 1000,
            #:min_value => code.min - 1000
            ).gsub(/chxr=.*/, "chxr=1,#{code.min},#{code.max}|2,#{test.min},#{test.max}")
  