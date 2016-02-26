Pod::Spec.new do |s|
  s.name            = 'DLSplashModule'
  s.version         = '0.0.0'
  s.platform        = :ios, "7.0"
  s.summary         = 'Module to provide Ad for splash screen.'
  s.author          = { 'Konrad Kierys' => 'konrad.kierys@asideas.de','Jacek Zapart' => 'jacek.zapart@asideas.de' }
  s.homepage        = 'http://<STASH_USER_NAME>@stash.grupa.onet/scm/pod/ios-splashmodule.git'
  s.license         = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
  s.source          = {
    # TODO: fix url for remote public location (not exist yet)
    :git => 'http://<STASH_USER_NAME>@stash.grupa.onet/scm/pod/ios-splashmodule.git',
    :tag => s.version.to_s
  }
  s.source_files = "include/**/*.h"
  s.vendored_libraries = 'libDLSplashModule.a'
end
