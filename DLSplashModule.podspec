Pod::Spec.new do |s|
  s.name            = 'DLSplashModule'
  s.version         = '0.0.0'
  s.platform        = :ios, "7.0"
  s.summary         = 'Module to provide Ad for splash screen.'
  s.author          = { 'Konrad Kierys' => 'konrad.kierys@asideas.de','Jacek Zapart' => 'jacek.zapart@asideas.de' }
  s.homepage        = 'http://stash.grupa.onet/projects/MSC/repos/dlsplashmodule'
  s.license         = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
  s.source          = {
    :git => 'ssh://git@stash.grupa.onet:7999/msc/dlsplashmodule.git',
    :tag => s.version.to_s
  }
  s.source_files = "include/**/*.h"
  s.vendored_libraries = 'libDLSplashModule.a'
end
