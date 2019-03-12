# frozen_string_literal: true

require "docker-api"

# These all need to be required so the various classes can be registered in a
# lookup table of package manager names to concrete classes.
require "dependabot/bundler/file_fetcher"
require "dependabot/bundler/file_parser"
require "dependabot/bundler/update_checker"
require "dependabot/bundler/file_updater"
require "dependabot/bundler/metadata_finder"
require "dependabot/bundler/requirement"
require "dependabot/bundler/version"

require "dependabot/pull_request_creator/labeler"
Dependabot::PullRequestCreator::Labeler.
  register_label_details("bundler", name: "ruby", colour: "ce2d2d")

require "dependabot/dependency"
Dependabot::Dependency.register_production_check(
  "bundler",
  lambda do |groups|
    return true if groups.empty?
    return true if groups.include?("runtime")
    return true if groups.include?("default")

    groups.any? { |g| g.include?("prod") }
  end
)

module Dependabot
  module Bundler
    @project_root = nil

    class << self
      attr_accessor :project_root
    end
  end
end

require "bundler"

module Bundler
  class << self
    def eval_gemspec(path, contents)
      project_root = detect_project_root(path.to_s)

      unless project_root
        raise "Can't eval gemspec #{path} - can't detect project root"
      end

      relative_path = path.to_s.delete_prefix(project_root + File::SEPARATOR)

      eval_gemspec_in_container(project_root, relative_path)
    end

    def eval_gemspec_in_container(project_root, gemspec_path)
      container = Docker::Container.create(
        "Image" => "eval-gemspec",
        "Cmd" => ["ruby", "/eval_gemspec.rb", gemspec_path],
        "NetworkDisabled" => true
      )

      tar_file = Docker::Util.create_dir_tar(project_root)

      container.archive_in_stream("/project", overwrite: true) do
        tar_file.read(Excon.defaults[:chunk_size]).to_s
      end

      tar_file.close
      FileUtils.rm(tar_file.path)

      container.start
      container.attach { |stream, chunk| puts "#{stream}: #{chunk}" }
      container.wait

      yaml_spec = container.read_file("/out.yaml")
      container.delete(force: true)

      Gem::Specification.from_yaml(yaml_spec)
    end

    def detect_project_root(path)
      install_path = Bundler.install_path.to_s
      if path.start_with?(install_path)
        relative_path = path.delete_prefix(install_path + File::SEPARATOR)
        dir_name = relative_path.split(File::SEPARATOR).first
        return File.join(install_path, dir_name)
      end

      project_root = Dependabot::Bundler.project_root
      return project_root if project_root && path.start_with?(project_root)
    end
  end
end
