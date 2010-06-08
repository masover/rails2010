file 'public/slides.html' => ['slides.md', 'Rakefile'] do |t|
  require 'slidedown'
  sd = SlideDown.new(File.read('slides.md'), :stylesheets => ['slides.css'])
  File.open 'public/slides.html', 'w' do |out|
    out.write sd.render('default')
  end
end

task :default => ['public/slides.html']