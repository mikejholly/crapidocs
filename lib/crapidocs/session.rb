module CrapiDocs
  class Session
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
          headers: env,
          uri: uri
        },
        response: {
          status: status,
          headers: headers,
          body: body
        }
      }

      path = cleaned_path(uri)
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
      JSON.parse(res[:body])
    end

    private

    def merge_params(reqs)
      params = reqs.reduce({}) do |hash, r|
        ps = if r[:headers]['Content-Type'] =~ /json/
          JSON.parse(r[:body]) rescue {}
        else
          Rack::Utils.parse_nested_query(r[:body])
        end
        hash.merge(ps)
      end
      params.delete('format')
      params
    end

    def cleaned_path(uri)
      last = nil
      uri.path.split('/').reject(&:blank?).reduce('') do |cleaned, part|
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
      (uri.to_s =~ @pattern).present?
    end
  end
end
