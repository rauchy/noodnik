# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "noodnik"
  s.summary = "A simple Rails solution for reminding users to do stuff."
  s.description = "A simple Rails solution for reminding users to do stuff."
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.version = "0.1.0"
end
