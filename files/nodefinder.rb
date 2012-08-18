#!/opt/puppet/bin/ruby

# Finds a node in the ENC whose parameter given as
# the first commandline arguments matches the regexp
# given as the second argument.
#
# If a node is found, its name is printed on stdout,
# making this command feasible to be used in a puppet
# generate() function.
#
require 'net/https'
require 'yaml'

if ARGV.size < 2 || ARGV.size % 2 != 0
  fail "Usage: #$0 <param> <query> [param query...]"
end

# Param
query = ARGV.each_slice(2).inject({}) do |h, (k,v)|
  h.update(k => Regexp.compile(v))
end

# Client
http = Net::HTTP.new('localhost', 443)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# Request
resp = http.get('/nodes', 'Accept' => 'yaml')
nodes = YAML.load(resp.body)

# Find
result = nodes.find do |node|
  query.all? {|k,v| node['parameters'][k] =~ v}
end

# Print result
if result
  puts result['name']
  exit 0
else
  exit 1
end
