require 'rubygems'
require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'
require 'tmpdir'
require 'sprockets'

Bundler.require

def generate_codo_docs
    #if `git status -s`
    #    puts "Error: uncommitted changes.  You must commit before continuing"
    #    return
    #end
    
    original_dir = Rake.application.original_dir
    
    Dir.mktmpdir do |dir|
        tmpdir_path = Pathname.new(dir)
        puts "Created tmpdir at: #{tmpdir_path}"

        puts "Invoking codo..."
        puts `codo #{original_dir}/lib/assets/javascripts/core`
        
        puts "Contents of docs/ is:"
        puts `ls -l #{original_dir}/docs`
        
        puts "Copying docs/* to #{tmpdir_path}..."
        puts `cp -R #{original_dir}/docs/* #{tmpdir_path}`
        
        puts "Contents of #{tmpdir_path}/ is:"
        puts `ls -l #{tmpdir_path}`
        
        puts "Deleting docs/ from master"
        puts `rm -rf #{original_dir}/docs`
        
        puts "Checking out gh-pages branch..."
        puts `git checkout gh-pages`
        
        puts "Testing if docs/ directory exists..."
        `mkdir #{original_dir}/docs` unless File.directory? "#{original_dir}/docs"
        
        puts "Copying files back to docs/"
        puts `cp -R #{tmpdir_path}/* #{original_dir}/docs/`
        
        puts "Staging files for commit..."
        puts `git add #{original_dir}/docs`
        
        puts "The following files have been modified:"
        puts `git status`
        
        puts "Please commit and push to origin/gh-pages to update docs"
    end    
    
end

def build_assets( source_file_name, output_file_name )
    puts "Compiling #{source_file_name}..."

    root    = Pathname(File.dirname(__FILE__))
    logger  = Logger.new(STDOUT)

    sprockets = Sprockets::Environment.new(root) do |env|
        env.logger = logger
    end

    assets_path = root.join('lib', 'assets', 'javascripts').to_s
    sprockets.append_path(assets_path)

    assets = sprockets.find_asset(source_file_name)
    assets.write_to(root.join('build', output_file_name))
end

task :codo do
    generate_codo_docs
end

# With thanks to Simone Carletti:
# http://www.simonecarletti.com/blog/2011/09/using-sprockets-without-a-railsrack-project/

task :build_container do
    build_assets 'container.js', 'frappuccino-container.js'
end

task :build do
    build_assets 'framework.js', 'frappuccino-core.js'
end

