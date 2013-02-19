guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' },
:rspec => true,
:cucumber => false,
:test_unit => false,
:aggressive_kill => true do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^extras/.+\.rb$})
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch(%r{^app/uploaders/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('spec/support/**/*.rb') { :rspec }
end

guard 'rspec', :cli => "--color --format nested --fail-fast --drb --tag current",
:notification => false,
:all_after_pass => false,
:all_on_start => false do

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('spec/spec_helper.rb')                        { "spec" }
end
