require 'test/unit'
require 'iconv'
require 'tempfile'

module DetencHelper
  US_ASCII     = 'US-ASCII'
  UTF_8        = 'UTF-8'
  WINDOWS_1252 = 'WINDOWS-1252'
  ISO_8859_15  = 'ISO-8859-15'
  UNKNOWN      = 'UNKNOWN'

  def detenc(data)
    t = Tempfile.new('detenc')
    t << data
    t.close
    `#{File.dirname(__FILE__)}/../bin/detenc -q #{t.path}`.strip
  end
end

