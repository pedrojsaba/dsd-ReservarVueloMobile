require 'yaml'

RUTAS_WDSL = YAML::load_file(File.join(Rails.root, "config", "rutas_wdsl.yml"))