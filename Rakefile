require "bundler/gem_tasks"

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
        puts `codo #{original_dir}`
        
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
        
        puts "Copying files back to docs/"
        puts `cp -R #{tmpdir_path}/* #{original_dir}/docs/`
    end    
    
end

task :codo do
    generate_codo_docs
end
