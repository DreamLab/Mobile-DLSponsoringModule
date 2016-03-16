fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
### build_pod_static_lib
```
fastlane build_pod_static_lib
```
Builds static library, documentation, podspec and changelog and put it in one directory.

Parameters:

* **`version`**: Version number

* **`project_name`**: Name of the project. (`PROJECT_NAME`)

* **`scheme`**: XCode scheme of universal library. (`UNIVERSAL_SCHEME_NAME`)

* **`output_dir`**: Path to output directory. (`OUTPUT_DIR`)
### build_documentation
```
fastlane build_documentation
```
Build Documentation

* **`output_dir`**: Path to output directory.
### unit_tests
```
fastlane unit_tests
```
Run Unit tests
### make_changelog
```
fastlane make_changelog
```


----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools).  
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).  
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane).