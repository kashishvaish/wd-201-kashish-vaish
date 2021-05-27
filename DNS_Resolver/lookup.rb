def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end
  
  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument
  
  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  
  # ..
  # ..
  def parse_dns(raw)
    hash = {}
    raw.each do |x|
        parts = x.split(",").map{|n| n.strip}
        hash[parts[1]] = {
            "destination" => parts[2],
            "type" => parts[0]
        }
    end
    return hash
  end

  def resolve(records, chain, domain)
    if records[domain] == nil
        puts "Error: record not found for #{domain}"
        exit
    end
    to = records[domain]["destination"]
    chain.push(to)
    if records[domain]["type"] == 'A'       
        return chain
    elsif records[domain]["type"] == 'CNAME'
        return resolve(records, chain, to)
    else
        puts "Error: inconsistent records found"
        exit
    end
  end
  # ..
  # ..
  
  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")