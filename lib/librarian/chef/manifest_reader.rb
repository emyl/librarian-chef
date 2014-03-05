require 'json'
require 'yaml'

require 'librarian/manifest'

require_relative 'metadata'

module Librarian
  module Chef
    module ManifestReader
      extend self

      MANIFESTS = %w(metadata.json metadata.yml metadata.yaml metadata.rb)

      def manifest_path(path)
        MANIFESTS.map{|s| path.join(s)}.find{|s| s.exist?}
      end

      def read_manifest(name, manifest_path)
        case manifest_path.extname
        when ".json" then JSON.parse(binread(manifest_path))
        when ".yml", ".yaml" then YAML.load(binread(manifest_path))
        when ".rb" then compile_manifest(name, manifest_path.dirname)
        end
      end

      def compile_manifest(name, path)
        md = Metadata.new(path.join('metadata.rb').to_s)
        { "name" => name, "version" => md.version, "dependencies" => md.dependencies }
      end

      def manifest?(name, path)
        path = Pathname.new(path)
        !!manifest_path(path)
      end

      def check_manifest(name, manifest_path)
        manifest = read_manifest(name, manifest_path)
        manifest["name"] == name
      end

    private

      if File.respond_to?(:binread)
        def binread(path)
          File.binread(path)
        end
      else
        def binread(path)
          File.read(path)
        end
      end

    end
  end
end
