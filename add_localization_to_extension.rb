require 'xcodeproj'
project_path = 'BeenThere.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == 'PlaceShareExtension' }
file_ref = project.files.find { |f| f.path =~ /Localizable\.xcstrings/ }

if file_ref
  unless target.resources_build_phase.files_references.include?(file_ref)
    target.resources_build_phase.add_file_reference(file_ref, true)
    project.save
    puts "Added Localizable.xcstrings to PlaceShareExtension resources."
  else
    puts "Localizable.xcstrings is already in the PlaceShareExtension resources."
  end
else
  puts "Could not find Localizable.xcstrings file reference."
end
