#!/usr/bin/env ruby

require 'sinatra'
require 'slidedown'

slide_path = File.join File.dirname(__FILE__), 'slides.md'

get '/' do
  SlideDown.new(File.read(slide_path), :stylesheets => ['slides.css']).render('default')
end