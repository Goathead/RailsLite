require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './params'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    unless already_built_response?
      @res["location"] = url
      @res.status = 302
      @already_built_response = true
    else
      raise "error"
    end
    
    session.store_session(@res)
  end

  def render_content(content, content_type)
    unless already_built_response?
      @res.body = content
      @res.content_type = content_type
      @already_built_response = true
    else
      raise "error"
    end
    
    session.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    content = ERB.new(template).result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render name unless already_built_response?
  end

end
