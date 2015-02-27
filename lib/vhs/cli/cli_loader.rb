module VHS
  class CLILoader

    # Public: configures VHS from .vhs.yml config file and loads it.
    def load_vhs
      configure_vcr
      configure_vhs
      VHS.load
    end

  private

    def configure_vcr
      VCR.configure do |vcr|
        cli_config['vcr'].each do |key, value|
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
        cli_config['vhs'].each do |key, value|
          vhs.send "#{ key }=", value
        end
      end
    end

    def cli_config
      @cli_config ||= begin
                        pwd = "#{ `pwd` }".gsub(/\n/, '')
                        YAML.load_file "#{ pwd }/.vhs.yml"
                      end
    end

  end
end

