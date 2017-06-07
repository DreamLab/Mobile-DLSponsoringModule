Pod::Spec.new do |s|
  s.name            = 'DLSponsoringBannerModuleCode'
  s.version         = '0.0.1'
  s.platform        = :ios, "7.0"
  s.summary         = 'Module to provide Sponsoring Module Ad.'
  s.author          = { 'Paweł Kordal' => 'pawel.kordal@dreamlab.pl', 'Konrad Kierys' => 'konrad.kierys@dreamlab.pl','Jacek Zapart' => 'jacek.zapart@dreamlab.pl' }
  s.homepage        = 'http://stash.grupa.onet/projects/MSC/repos/DLSponsoringBannerModule'
  s.license         = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
  s.source          = {
    :git => 'ssh://git@stash.grupa.onet:7999/mss/ios-sponsoringbannermodule.git',
    :tag => s.version.to_s
  }
  s.framework = "AdSupport"
  s.source_files = "DLSponsoringBannerModule/{Private,Public}/*.{h,m}"
end
