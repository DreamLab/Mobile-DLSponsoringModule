Pod::Spec.new do |s|
  s.name            = 'DLSponsoringBanerModule'
  s.version         = '0.0.1'
  s.platform        = :ios, "7.0"
  s.summary         = 'Module to provide Sponsoring Module Ad.'
  s.author          = { 'Paweł Kordal' => 'pawel.kordal@dreamlab.pl", 'Konrad Kierys' => 'konrad.kierys@dreamlab.pl','Jacek Zapart' => 'jacek.zapart@dreamlab.pl' }
  s.homepage        = 'http://stash.grupa.onet/projects/MSC/repos/dlsponsoringbanermodule'
  s.license         = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
  s.source          = {
    :git => 'ssh://git@stash.grupa.onet:7999/msc/dlsponsoringbanermodule.git',
    :tag => s.version.to_s
  }
  s.framework = "AdSupport"
  s.source_files = "include/**/*.h"
  s.vendored_libraries = 'libDLSponsoringBanerModule.a'
end
