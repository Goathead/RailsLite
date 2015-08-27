require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  #
  # You haven't done routing yet; but assume route params will be
  # passed in as a hash to `Params.new` as below:
  def initialize(req, route_params = {})
    body, query = req.body, req.query_string

    query_params = query ? parse_www_encoded_form(query) : {}
    body_params = body ? parse_www_encoded_form(body) : {}
    @params = route_params.merge(query_params).merge(body_params)
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  # this will be useful if we want to `puts params` in the server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    param_hash = {}
    URI::decode_www_form(www_encoded_form).each do |kv_pair|
      current = param_hash
      keys = parse_key(kv_pair.first)
      val = kv_pair.last

      keys.each do |key|
        if key == keys.last
          current[key] = val
        else
          current[key] ||= {}
          current = current[key]
        end
      end
    end
    param_hash
  end

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
