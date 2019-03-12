require "bundler/psyched_yaml"

gemspec_path = ARGV[0]
contents = File.read(gemspec_path)
gemspec = eval(contents, TOPLEVEL_BINDING.dup, gemspec_path)
open("/out.yaml", "w") { |f| f.write(gemspec.to_yaml) }
