# 帮助文件
module JsonApiHelpers

  def json
    JSON.parse(response.body)
  end

  # 从server返回的data不是symbol，是string
  def json_data
    json['data']
  end
    
end