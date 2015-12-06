module CrapiDocs
  class Session
    attr_reader :results

    def initialize(pattern)
      @pattern = pattern
      @results = Hash.new { |h, k| h[k] = {} }
    end

    def track(req, res)
      return unless relevant?(req.uri)

      path = clean_path(req.uri.path)

      @results[path][req.method] ||= []
      @results[path][req.method] << { req: req, res: res }
    end

    private

    def clean_path(path)
      last = nil
      path.split('/').reject(&:blank?).reduce('') do |cleaned, part|
        part = ":#{last.singularize}_id" if part =~ /^\d+$/
        part = ':token' if tokenish?(part)
        last = part
        "#{cleaned}/#{part}"
      end
    end

    def tokenish?(s)
      s =~ /\d+/ && s =~ /[a-zA-Z]+/ && s.length >= 10
    end

    def relevant?(uri)
      uri.to_s =~ @pattern
    end
  end
end
