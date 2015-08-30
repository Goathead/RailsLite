require 'uri'

class Params

  def initialize(req, route_params = {})
    body, query = req.body, req.query_string

    query_params = query ? parse_www_encoded_form(query) : {}
    body_params = body ? parse_www_encoded_form(body) : {}
    @params = route_params.merge(query_params).merge(body_params)
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # user[address][street]=main&user[address][zip]=89436
  # returns
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

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end