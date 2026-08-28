require 'xcodeproj'
project_path = 'BeenThere.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == 'PlaceShareExtension' }
file_ref = project.files.find { |f| f.path =~ /AppRowStyle\.swift/ }
unless target.source_build_phase.files_references.include?(file_ref)
  target.add_file_references([file_ref])
  project.save
  puts "Added AppRowStyle.swift to PlaceShareExtension target."
else
  puts "AppRowStyle.swift is already in the PlaceShareExtension target."
end
