class Api::V1::TemplatesController < Api::BaseController
  # GET /api/v1/template/:id
  def show
    @template = Template.active.find_by(id: params[:id])
    if @template
      render "templates/show"
    else
      render json: { error: "Template not found" }, status: :not_found
    end
  end

  # GET /api/v1/template/find_by_domain/
  def find_by_domain
    origin = find_host(request)
    domain = Domain.find_by(fqdn: origin)
    @template = Template.active.find_by(id: domain&.template_id)

    if @template
      render "templates/show"
    else
      render json: { error: "Template not found for the given domain: #{origin}" }, status: :not_found
    end
  end

  private

  def find_host(request)
    host = nil

    if request.original_url && (match_data = request.original_url.match(%r{https?://([^/]+)}))
      host = match_data[1]
    end

    return host if host

    return "www.medispeak.in" if request.referer&.include?("medispeak.in")

    nil
  end
end
