if ActiveSupport::VERSION::STRING == '4.2.11'
  old_verbose, $VERBOSE = $VERBOSE, nil
  require 'bigdecimal'
  require 'bigdecimal/util'
  $VERBOSE = old_verbose
end

