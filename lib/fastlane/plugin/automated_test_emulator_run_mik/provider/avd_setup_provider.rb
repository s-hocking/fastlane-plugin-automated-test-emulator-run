module Fastlane
  module Provider

    class AVD_scheme
      attr_accessor :avd_name, :create_avd_package, :create_avd_device, :create_avd_tag, :create_avd_abi, :create_avd_hardware_config_filepath, :create_avd_additional_options, 
                    :launch_avd_launch_binary_name, :launch_avd_additional_options
    end

    class AvdSchemeProvider
      
        def self.get_avd_schemes(params)
        
          # Read JSON into string variable
          avd_setup_json = read_avd_setup(params)
          if avd_setup_json.nil? 
            throw_error("Unable to read AVD_setup.json. Check JSON file structure or file path.")
          end

          # Read JSON into Hash
          avd_setup = JSON.parse(avd_setup_json)
          avd_hash_list = avd_setup['avd_list']

          # Create AVD_scheme objects and fill them with data
          avd_scheme_list = []
          for i in 0...avd_hash_list.length
            avd_hash = avd_hash_list[i]

            avd_scheme = AVD_scheme.new
            avd_scheme.avd_name = avd_hash['avd_name']

            avd_scheme.create_avd_package = avd_hash['create_avd_package']
            avd_scheme.create_avd_device = avd_hash['create_avd_device']
            avd_scheme.create_avd_tag = avd_hash['create_avd_tag']
            avd_scheme.create_avd_abi = avd_hash['create_avd_abi']
            avd_scheme.create_avd_hardware_config_filepath = avd_hash['create_avd_hardware_config_filepath']

            avd_scheme.launch_avd_launch_binary_name = avd_hash['launch_avd_launch_binary_name']
            avd_scheme.launch_avd_additional_options = avd_hash['launch_avd_additional_options']

            errors = check_avd_fields(avd_scheme)
            unless errors.empty?
              error_log = "Error! Fields not found in JSON: \n"
              errors.each { |error| error_log += error + "\n" }
              throw_error(error_log)
            end

            avd_scheme_list << avd_scheme
          end

          return avd_scheme_list
        end 

        def self.read_avd_setup(params)
          if File.exists?(File.expand_path("#{params[:AVD_setup_path]}"))
            file = File.open(File.expand_path("#{params[:AVD_setup_path]}"), "rb")
            json = file.read
            file.close
            return json
          else
            return nil
          end
        end

        def self.check_avd_fields(avd_scheme)
          errors = []
            
          if avd_scheme.avd_name.nil? 
              errors.push("avd_name not found")
          end
          if avd_scheme.create_avd_package.nil? 
              errors.push("create_avd_package not found")
          end
          if avd_scheme.create_avd_device.nil? 
              errors.push("create_avd_device not found")
          end
          if avd_scheme.create_avd_tag.nil? 
              errors.push("create_avd_tag not found")
          end
          if avd_scheme.create_avd_abi.nil? 
              errors.push("create_avd_abi not found")
          end
          if avd_scheme.create_avd_hardware_config_filepath.nil? 
              errors.push("create_avd_hardware_config_filepath not found")
          end
          if avd_scheme.launch_avd_launch_binary_name.nil?
            errors.push("launch_avd_launch_binary_name not found")
          end
          if avd_scheme.launch_avd_additional_options.nil? 
              errors.push("launch_avd_additional_options not found")
          end
          return errors
        end

        def self.throw_error(message) 
          UI.message("Error: ".red + message.red)
          raise Exception, "Lane was stopped by plugin"
        end
    end
  end
end