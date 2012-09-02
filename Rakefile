require "bundler/gem_tasks"

def generate_codo_docs
    #if `git status -s`
    #    puts "Error: uncommitted changes.  You must commit before continuing"
    #    return
    #end
    
    Dir.mktmpdir do |dir|
        tmpdir_path = Pathname.new(dir)
        puts "Created tmpdir at: #{tmpdir_path}"

        puts "Invoking codo..."
        puts `codo`
        
        puts "Copying docs/* to #{tmpdir_path}..."
        puts "cp -R ./docs #{tmpdir_path}"
        
        puts "Checking out gh-pages branch..."
        puts `git checkout gh-pages`
        
        puts "Copying files back to docs/"
        puts `cp -R #{tmpdir_path} ./docs/`
    end    
    
end

task :codo do
    generate_codo_docs
end
