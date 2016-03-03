require 'optparse'

class DNSLookup
  def initialize
    @type = ''
    @domain = ARGV.shift

    parse_options
    setup_query_servers
    lookup_with_options
  end

  def parse_options
    OptionParser.new do |opt|
      opt.banner = "Usage lookup [options]"

      opt.on("-mx", "--email", "Return MX records") do |v|
        @type = 'mx'
      end

      opt.on("-a", "--address", "Return A type records") do |v|
        @type = 'a'
      end

      opt.on("-c", "--alias", "Return C type records") do |v|
        @type = 'c'
      end

      opt.on("-txt", "--text", "Return TXT type records") do |v|
        @type = 'txt'
      end

      opt.on("-s", "--server=SERVER", "Specify specific name server to query") do |v|
        @single_server = v
      end

      opt.on("-h", "--help", "Prints this help") do
        puts opt
        exit
      end
    end.parse!
  end

  def setup_query_servers
    @servers = []

    if @single_server
      @servers << @single_server
    else
      @servers = ['8.8.8.8', '8.8.4.4']
    end
  end

  def lookup_with_options
    case @type
    when 'mx'
      query_command('mx')
    when 'a'
      query_command('a')
    when 'c'
      query_command('c')
    when 'txt'
      query_command('txt')
    else
      query_command('any')
    end
  end

  def query_command(type)
    @servers.each do |server|
      if type == 'any'
        check = `dig @#{server} #{type} #{@domain}`
      else
       check = `dig @#{server} #{@domain} #{type} +short`
      end

      puts "Checking servers: #{server}"
      puts check
      puts
    end
  end
end