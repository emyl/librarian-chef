module Librarian
  module Chef
    # Read metadata from a Chef cookbook in a similar way
    # as Chef::Cookbook::Metadata does.
    #
    # It reads only necessary items (version and dependencies),
    # silently ignoring the other entries.
    class Metadata

      attr_reader :dependencies

      def initialize(file_name)
        @dependencies = {}
        @version      = "0.0.0"
        self.instance_eval File.read(file_name)
      end

      def depends(cookbook, version_constraint = nil)
        version_constraint ||= ">= 0.0.0"
        @dependencies[cookbook] = parse_version_constraint(version_constraint)
      end

      def version(number = nil)
        @version = parse_version(number) if number
        @version
      end

      # Ignore any other definition
      def method_missing(name, *args, &block)
        nil
      end

      private

      # Simple version parser
      #
      # Allowed formats:
      #   x.x
      #   x.x.x
      def parse_version(version)
        raise ::Librarian::Error, "Invalid cookbook version" unless version =~ /^(\d+)\.(\d+)(\.(\d+))?$/
        version
      end

      # Parse version constraint
      #
      # Allowed operators:
      #   <
      #   >
      #   =
      #   <=
      #   >=
      #   ~>
      def parse_version_constraint(version_constraint)
        if version_constraint.index(" ").nil?
          version  = parse_version(version_constraint)
          operator = "="
          "#{operator} #{version}"
        elsif version_constraint =~ /^(<|>|=|<=|>=|~>) (.+)$/
          version  = parse_version($2)
          operator = $1
          "#{operator} #{version}"
        else
          raise ::Librarian::Error, "Invalid version constraint"
        end
      end

    end
  end
end
