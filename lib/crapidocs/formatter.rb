module CrapiDocs
  class Formatter
    def initialize(session)
      @session = session
    end

    def to_md
      regions = { routes: format_routes, details: format_details }
      regions.reduce(template) do |t, (k, v)|
        t.gsub("{#{k}}", v.join("\n"))
      end
    end

    private

    def anchor(s)
      s.gsub(/[^a-zA-Z0-9]/, '')
    end

    def paths
      @session.results.keys.sort
    end

    def format_routes
      paths.map { |path| "* [#{path}](##{anchor(path)})" }
    end

    def format_details
      paths.map do |path|
        ["### <a name='#{anchor(path)}'></a>#{path}"] + format_methods(path)
      end
    end

    def format_body(body)
      JSON.pretty_generate(JSON.parse(body)) if body
    rescue JSON::ParserError
      body
    end

    def format_params(reqs)
      params = reqs.reduce({}) do |hash, r|
        ps = Rack::Utils.parse_nested_query(r[:req].input)
        hash.merge(ps)
      end
      params.delete('format')
      return '' unless params.keys.any?
      JSON.pretty_generate(params)
    end

    def format_methods(path)
      methods = @session.results[path]
      methods.keys.map { |method| format_method(method, methods[method]) }
    end

    def format_method(method, cycles)
      cycles = cycles.select { |c| r[:res].status / 100 == 2 }

      ps = format_params(cycles)

      str = ["#### #{method}"]
      str += ['Parameters:', "```json\n#{ps}\n```"] if ps.present?

      if cycles.any? && cycles.first.body.present?
        body = format_body(cycles.first[:res].body)
        str += ['Example Response:', "```json\n#{body}\n```"]
      end

      str.join("\n\n")
    end
  end
end
