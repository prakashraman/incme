require 'find'
require 'FileUtils'

$options = {}
ARGV.each do |arg|
  res = (/--(.+)=(.+)/ =~ arg)
  val = $2
  $options[$1.gsub("-", "_").to_sym] = val if res and $1 and val
end

# UTILS
# PUSHES ON THE STANDARD OUTPUT OR TO A LOG FILE
def log(str, log_type = :info)
  str = "- ERROR - #{str}" if log_type == :error
  puts str
end

# USAGE OF THE SCRIPT
def usage
  puts "USAGE: ruby site-maker.rb --source-dir=<path-to-source-dir> --dest-dir=<path-to-dest-dir>"
end

def remove_trailing_slash(str)
  str.gsub(/(\/|\\)$/, "")
end


if (not $options[:source_dir] or (not $options[:dest_dir]))
  usage
  exit
end

SOURCE_DIR = remove_trailing_slash($options[:source_dir])
DEST_DIR = remove_trailing_slash($options[:dest_dir])
EXCLUDE_EXTS = ["js", "gif", "jpeg", "jpg", "png"]
INCLUDES_DIR = SOURCE_DIR + "/" + "_includes_"
NOT_ALLOWED_DIRS = ["/", "/home", "/home/Users", "c:\\", "d:\\"] #"

if NOT_ALLOWED_DIRS.include?(SOURCE_DIR.strip.downcase)
  puts "The --source-dir cannot be amoung #{NOT_ALLOWED_DIRS.inspect}"
  puts "Exiting..."
  exit
end

if NOT_ALLOWED_DIRS.include?(DEST_DIR.strip.downcase)
  puts "The --dest-dir cannot be amoung #{NOT_ALLOWED_DIRS.inspect}"
  puts "Exiting..."
  exit
end

if SOURCE_DIR == DEST_DIR
  puts "The --source-dir cannot be the same as the --dest-dir"
  puts "Exiting..."
end

class Maker
  
  # RETURNS THE LIST OF FILES TO BE OPERATED ON
  def operate_on_file
    files = []
    Find.find(SOURCE_DIR){|path| files << path}
    files.reject{|path| (/#{INCLUDES_DIR}/ =~ path) or (path == SOURCE_DIR)} # Removes all the _includes_ files from the list
  end

  def copy_file(from, to)
    log "Copying #{from} to destination"
    File.copy(from, to)
  end
  
  def clean_destination_dir
    # DELETING THE DESTINATION DIRECTORY GENERATED FILES
    log "Deleting the destination folder..."
    FileUtils.rm_rf(DEST_DIR)

    # CREATING AN EMPTY DESTINATION DIRECTORY
    log "Creating destination folder..."
    Dir.mkdir DEST_DIR
  end
  
  # THE MAKER "INC" COMMAND
  def inc(inc_name)
    IO.read(INCLUDES_DIR + "/" + inc_name)
  rescue Exception => e
    log "#{e.message}", :error
    log "Skipping include #{inc_name}", :error
    ""
  end


  # PERFORMS THE TEXT SUBSTITUTION ON THE FILE
  def _perform(text)
    lines = text.split("\n")
    lines.map! {|line|
      line.gsub(/\[\[(.)+\]\]/i){|found|
        /\[\[([a-z_]*): ([a-z_]*)\]\]/i =~ found
        _perform(self.send($1.to_sym, $2))
      }
    }
    lines.join("\n")
  end

  # ISSUES THE TEXT SUBSTITUTION COMMAND ON THE FILE
  def perform(from, to)
    log "Performing substitution in #{from}"
    text = _perform(IO.read(from))
    open(to, 'w'){|f| f << text}
  end
  
  # RETURNS TRUE IF THIS FILE SHOULD BE EXCLUDED FORM THE "PERFORM" COMMAND.
  # THIS FILE IS DIRECTLY BE COPIED OVER TO THE DESTINATION FOLDER
  def exclude_file?(path)
    EXCLUDE_EXTS.include?(File.extname(path).sub(".", "").downcase)
  end
  
  def run(files)
    files.each do |path|
      gen_path = path.sub(/#{SOURCE_DIR}/, "#{DEST_DIR}")
      if FileTest.directory?(path)
        log "Creating directory '#{gen_path}'"
        Dir.mkdir(gen_path)
      else
        exclude_file?(path) ? copy_file(path, gen_path) : perform(path, gen_path)
      end
    end
  end
  
end

maker = Maker.new
files = maker.operate_on_file
maker.clean_destination_dir
maker.run files

log "\nSUCCESS: Your files have been generated at '#{DEST_DIR}'\n"