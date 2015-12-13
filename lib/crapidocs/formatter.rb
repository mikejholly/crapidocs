require 'erubis'

module CrapiDocs
  class Formatter
    def initialize(session)
      @session = session
    end

    def to_md
      Erubis::Eruby.new(load_template).result(binding)
    end

    private

    def load_template
      File.open("#{TEMPLATE_DIR}/layout.md.erb").read
    end

    def anchor(s)
      s.gsub(/[^a-zA-Z0-9]/, '')
    end
  end
end
