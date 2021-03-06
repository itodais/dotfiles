require 'itamae'
require 'thor'

module Itamae
  class CLI < Thor
    class_option :log_level, type: :string, aliases: ['-l'], default: 'info'
    class_option :color, type: :boolean, default: true

    def initialize(args, opts, config)
      opts = Config.new(opts).load
      super(args, opts, config)

      Itamae.logger.level = ::Logger.const_get(options[:log_level].upcase)
      Itamae.logger.formatter.colored = options[:color]
    end

    def self.define_exec_options
      option :dot, type: :string, default: nil, desc: "Only write dependency graph in DOT", banner: "PATH"
      option :node_json, type: :string, aliases: ['-j']
      option :node_yaml, type: :string, aliases: ['-y']
      option :dry_run, type: :boolean, aliases: ['-n']
      option :shell, type: :string, default: "/bin/sh"
      option :ohai, type: :boolean, default: false, desc: "This option is DEPRECATED and will be inavailable."
    end

    desc "local RECIPE [RECIPE...]", "Run Itamae locally"
    define_exec_options
    def local(*recipe_files)
      if recipe_files.empty?
        raise "Please specify recipe files."
      end

      Runner.run(recipe_files, :local, options)
    end

    desc "ssh RECIPE [RECIPE...]", "Run Itamae via ssh"
    define_exec_options
    option :host, type: :string, aliases: ['-h']
    option :user, type: :string, aliases: ['-u']
    option :key, type: :string, aliases: ['-i']
    option :port, type: :numeric, aliases: ['-p']
    option :vagrant, type: :boolean, default: false
    option :ask_password, type: :boolean, default: false
    option :sudo, type: :boolean, default: true
    def ssh(*recipe_files)
      if recipe_files.empty?
        raise "Please specify recipe files."
      end

      unless options[:host] || options[:vagrant]
        raise "Please set '-h <hostname>' or '--vagrant'"
      end

      Runner.run(recipe_files, :ssh, options)
    end

    desc "docker RECIPE [RECIPE...]", "Create Docker image"
    define_exec_options
    option :image, type: :string, desc: "This option or 'container' option is required."
    option :container, type: :string, desc: "This option or 'image' option is required."
    option :tls_verify_peer, type: :boolean, default: true
    def docker(*recipe_files)
      if recipe_files.empty?
        raise "Please specify recipe files."
      end

      Runner.run(recipe_files, :docker, options)
    end

    desc "version", "Print version"
    def version
      puts "Itamae v#{Itamae::VERSION}"
    end
  end
end
