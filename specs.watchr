# Run me with:
#
#   $ watchr specs.watchr

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def run(cmd)
  puts(cmd)
  system(cmd)
end

def run_all_tests
  system( "rake -s test" )
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch( '^test/test_accept_media_types\.rb'   )  { run_all_tests }
watch( '^lib/rack/accept_media_types\.rb'    )  { run_all_tests }
watch( '^test/test_helper\.rb'               )  { run_all_tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }

