class WechatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify

  def show
    render :plain => params[:echostr]
  end

  def create
    keyword = params[:xml]['Content']

    method = get_method(keyword)
    # byebug
    @text = self.send(method.to_sym, keyword)
    # byebug
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

  def get_method(keyword)
    case keyword
    when /.*[吃什么|吃啥].*/
      'call_random_food'
    else
      'call_turing_robot'
    end
  end


  def call_turing_robot(keyword)
    TuringRobot.call(keyword)
  end

  def call_random_food(keyword)
    food = `python3 #{Rails.root.to_s}/lib_other/random_food.py`.chomp
    "今天吃#{food}吧"
  end


end
