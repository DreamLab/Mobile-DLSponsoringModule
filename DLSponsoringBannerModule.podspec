Pod::Spec.new do |s|
  s.name            = 'DLSponsoringBannerModule'
  s.version         = '1.6.100'
  s.platform        = :ios, "7.0"
  s.summary         = 'Module to provide Sponsoring Module Ad.'
  s.author          = { 'Paweł Kordal' => 'pawel.kordal@dreamlab.pl', 'Konrad Kierys' => 'konrad.kierys@dreamlab.pl','Jacek Zapart' => 'jacek.zapart@dreamlab.pl' }
  s.homepage        = 'http://stash.grupa.onet/projects/MSC/repos/DLSponsoringBannerModule'
  s.license         = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
  s.source          = {
    :git => 'ssh://git@stash.grupa.onet:7999/msc/DLSponsoringBannerModule.git',
    :tag => s.version.to_s
  }
  s.framework = "AdSupport"
  s.source_files = "include/**/*.h"
  s.vendored_libraries = 'libDLSponsoringBannerModule.a'
end
