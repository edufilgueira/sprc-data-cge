module ResponseSpecHelper

  def json
    JSON.parse(response.body)
  end

end
