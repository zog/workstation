require 'optparse'

S3CMD_PATH = '/opt/local/bin/s3cmd'
# HELPERS
########################
class Logger
  COLORS = {
    :bold  => 1,
    :red   => 31,
    :green => 32
  }
  
  def self.custom msg, color
    "\e[#{color}m#{msg}\e[0m"
  end
  
  COLORS.each do |color, code|
    eval "
      def self.#{color} msg
        custom msg, #{code}
      end
    "
  end
  
  def self.log msg
    puts green(msg)
  end
  
  def self.error msg
    raise bold(red(msg))
  end
  
  def self.puts_ok msg
    puts bold(green(msg))
  end
end

#########################
class Bucket
  VERBOSITY = 0
  @@current_bucket = nil
  
  def initialize bucket_name
    @name = bucket_name
  end
  
  def self.init bucket_name
    return if @@current_bucket == bucket_name
    Logger.log "Initializing conf for bucket #{bucket_name}"
    Logger.error "missing conf file ~/.s3cfg_#{bucket_name}" unless File.exists?(File.join(Dir.home, ".s3cfg_#{bucket_name}"))
    `cp ~/.s3cfg ~/.s3cfg.backup` if File.exists?(File.join(Dir.home, ".s3cfg"))
    `cp ~/.s3cfg_#{bucket_name} ~/.s3cfg`
    @@current_bucket = bucket_name
  end
  
  def name; @name end
  
  def self.restore
    Logger.log "Restoring intial conf"
    `mv ~/.s3cfg.backup ~/.s3cfg`
    @@current_bucket = nil
  end
  
  def self.get_bucket path, options={}
    dir_name = options[application] || path
    bucket = path.split('/').first
    self.init bucket
    `mkdir -p #{dir_name}` unless File.exists?(dir_name)
    Logger.log("Getting s3://#{path} to #{dir_name}")
    `#{S3CMD_PATH} get #{VERBOSITY > 0 ? "-v" : ""} --recursive --skip-existing s3://#{path}/ #{dir_name}`
    dir_name
  end
  
  def self.put_bucket path, options={}
    dir_name = options[:dir_name] || path
    bucket = path.split('/').first
    self.init bucket
    Logger.error("#{dir_name} does not exist") unless File.exists?(dir_name)
    Logger.log("Putting #{dir_name} to s3://#{path}/")
    puts "#{S3CMD_PATH} put #{VERBOSITY > 0 ? "-v" : ""} --recursive --skip-existing #{dir_name} s3://#{path}/"
    #`#{S3CMD_PATH} put #{VERBOSITY > 0 ? "-v" : ""} --recursive --skip-existing #{dir_name} s3://#{path}/`
    dir_name
  end
  
  def self.replicate src, dest, options={}
    tmp_dir_name = "tmp_#{src}"
    get_bucket src, :dir_name => tmp_dir_name
    put_bucket dest, :dir_name => "#{tmp_dir_name}/*"
    `rm -rf #{tmp_dir_name}` unless options[:keep_local_copy]
    nil
  end
end

#########################
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename(__FILE__)} [options] task params"

  opts.on('-s', '--source BUCKET', 'Source bucket') do |s|
    options[:source] = s
  end
  
  opts.on('-d', '--dest BUCKET', 'Destination bucket') do |d|
    options[:destination] = d
  end

  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end.parse!

SOURCE_BUCKET = options[:source] || ENV['SOURCE_BUCKET'] || 'luxurysociety_dev'
DEST_BUCKET = options[:destination] || ENV['DEST_BUCKET'] || 'luxurysociety_staging'

#source_bucket = Bucket.new(SOURCE_BUCKET)
#destination_bucket = Bucket.new(DEST_BUCKET)
#source_bucket.list
#Logger.log '----'
#puts source_bucket.list 10, true
#destination_bucket.list
#Bucket.restore
