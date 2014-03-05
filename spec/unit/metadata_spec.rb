require "librarian-chef"
require "librarian/chef/metadata"

module Librarian
  module Chef
    describe Metadata do

      context "depends" do
        it "should default version constraint to >= 0.0.0" do
          File.stub(:read).and_return("depends 'foo'\n")
          metadata = described_class.new("foo")
          expect(metadata.dependencies["foo"]).to eq(">= 0.0.0")
        end

        it "should default the operator to =" do
          File.stub(:read).and_return("depends 'foo', '1.0.0'\n")
          metadata = described_class.new("foo")
          expect(metadata.dependencies["foo"]).to eq("= 1.0.0")
        end

        %w(< > = <= >= ~>).each do |operator|
          it "should accept the #{operator} operator" do
            File.stub(:read).and_return("depends 'foo', '#{operator} 1.0.0'\n")
            metadata = described_class.new("foo")
            expect(metadata.dependencies["foo"]).to eq("#{operator} 1.0.0")
          end
        end

        it "should fail with a wrong operator" do
          File.stub(:read).and_return("depends 'foo', '>~ 1.0.0'\n")
          expect { described_class.new("foo") }.to raise_error(::Librarian::Error, "Invalid version constraint")
        end

        it "should fail with a wrong version format" do
          File.stub(:read).and_return("depends 'foo', '>= wrong'\n")
          expect { described_class.new("foo") }.to raise_error(::Librarian::Error, "Invalid cookbook version")
        end
      end

      context "version" do
        it "should allow version number in the format x.x.x" do
          File.stub(:read).and_return("version '1.0.0'\n")
          metadata = described_class.new("foo")
          expect(metadata.version).to eq("1.0.0")
        end

        it "should allow version number in the format x.x" do
          File.stub(:read).and_return("version '1.0'\n")
          metadata = described_class.new("foo")
          expect(metadata.version).to eq("1.0")
        end

        it "should fail with a wrong version format" do
          File.stub(:read).and_return("version 'wrong'\n")
          expect { described_class.new("foo") }.to raise_error(::Librarian::Error, "Invalid cookbook version")
        end
      end

      context "misc" do
        it "should ignore other definitions" do
          File.stub(:read).and_return("suggest 'foo'\n")
          metadata = described_class.new("foo")
          expect(metadata.dependencies).to eq({})
          expect(metadata.version).to eq("0.0.0")
        end

        it "should work with multiple definitions" do
          definition = %Q{
            maintainer "Myself"

            depends "foo"
            depends "bar", "~> 2.1.0"

            version "0.1.0"
          }
          File.stub(:read).and_return(definition)
          metadata = described_class.new("foo")
          expect(metadata.dependencies).to eq({ "foo" => ">= 0.0.0", "bar" => "~> 2.1.0" })
          expect(metadata.version).to eq("0.1.0")
        end
      end

    end
  end
end
