class WechatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify
  
  def show
    render :plain => params[:echostr]
  end

  def create
    Rails.logger.info request.body.read
    render 'wechat/info', layout: false, :formats => :xml
  end


  private

  def verify
    token = '12ab'
    tmpArr = [token, params[:timestamp], params[:nonce]]
    tmpArr.sort!
    tmpStr = tmpArr.join('')
    tmpStr = Digest::SHA1.hexdigest(tmpStr)
    if params[:signature] != tmpStr
      render :text => "Forbidden", :status => 403
    end
    xml_content = Crack::XML.parse(request.body.read)
    params[:xml] = JSON.parse(xml_content.to_json)['xml']
  end
end
