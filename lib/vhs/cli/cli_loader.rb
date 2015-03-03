module VHS
  class CLILoader
    #TODO turn this one into VHS::Loader and use it in spec/support/vhs.rb
    # Public: configures VHS from .vhs.yml config file and loads it.
    def load_vhs
      configure_vcr
      configure_vhs
      VHS.load
    end

    #TODO move it to config class?
    def cassettes_path
      config['vcr']['cassette_library_dir']
    end

  private

    def config
      @config ||= begin
                    pwd = "#{ `pwd` }".gsub(/\n/, '')
                    YAML.load_file "#{ pwd }/.vhs.yml"
                  end
    end

    def configure_vcr
      VCR.configure do |vcr|
        config['vcr'].each do |key, value|
          if vcr.respond_to? "#{ key }="
            vcr.send "#{ key }=", value
          else
            vcr.send key, value
          end
        end
      end
    end

    def configure_vhs
      VHS.configure do |vhs|
        config['vhs'].each do |key, value|
          vhs.send "#{ key }=", value
        end
      end
    end

  end
end

