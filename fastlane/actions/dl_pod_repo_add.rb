module Fastlane
  module Actions
    class DlPodRepoAddAction < Action
   
        def self.run(params)
        
          url = params[:url]
          name = params[:name]
          
          begin
            # if this fail, that means Cocoapods don't have given repo, we should install it
            result = Fastlane::Actions::sh("pod repo list | grep #{name}", log: false)
            Helper.log.info "Repo already exists in Cocoapods".green
          rescue
            result = Fastlane::Actions::sh("pod repo add #{name} #{url}")
            Helper.log.info "Repo added to Cocoapods".green
          end  
          
          return result
        end

        #####################################################
        # @!group Documentation
        #####################################################

        def self.description
          "Adds the repository to Cocoapods installation if was not added before"
        end

        def self.available_options
          [
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "DL_PODS_REPO_NAME",
                                       description: "Name of the repository",
                                       is_string:true,
                                       optional:false),
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "DL_PODS_REPO_URL",
                                       description: "URL of the repository",
                                       is_string:true,
                                       optional:false)
          ]
        end

        def self.author
          ['Jacek Zapart']
        end

        def self.is_supported?(platform)
          true
        end
        
      end
    end
  end
