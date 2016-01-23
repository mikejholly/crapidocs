module CrapiDocs
  class Session
    attr_reader :actions

    def initialize(pattern)
      @pattern = pattern
      @actions = {}
    end

    def track(args, result)
      uri, env = args
      status, headers, body = result
      body = body.respond_to?(:body) ? body.body : ''
      method = env['REQUEST_METHOD']

      return unless relevant?(uri)

      action = {
        request: {
          method: method,
          body: env['rack.input'].string,
          headers: clean_headers(env)
        },
        response: {
          status: status,
          headers: headers,
          body: body
        }
      }

      path = clean_path(uri.path)
      @actions[path] ||= {}
      @actions[path][method] ||= []
      @actions[path][method] << action
    end

    def paths
      @actions.keys.sort
    end

    def methods(path)
      @actions[path].keys.sort
    end

    def params(path, method)
      reqs = @actions[path][method].map { |a| a[:request] }
      params = merge_params(reqs)
      return nil unless params.keys.any?
      params
    end

    def body(path, method)
      res = @actions[path][method]
        .map { |a| a[:response] }
        .find { |r| r[:status] / 100 == 2 }
      return nil unless res
      parse_body(res[:body])
    end

    def merge(sessions)
      sessions = [sessions] unless sessions.is_a?(Array)
      @actions = sessions.reduce(@actions) do |a, session|
        a.deep_merge(session.actions)
      end
    end

    private

    def parse_body(body)
      JSON.parse(body)
    rescue
      Rack::Utils.parse_nested_query(body)
    end

    def merge_params(reqs)
      params = reqs.reduce({}) do |hash, r|
        hash.merge(parse_body(r[:body]))
      end
      params.delete('format')
      params
    end

    def clean_headers(headers)
      headers.delete_if { |k, _v| k =~ /^(sinatra|rack)\./ }
    end

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
      (s =~ /\d+/ && s =~ /[a-zA-Z]+/ && s.length >= 10) == true
    end

    def relevant?(uri)
      (uri.to_s =~ @pattern).present?
    end
  end
end
