class SwaggerEditorController < ApplicationController
  
  #import swagger parser
  require "swagger_parser"
  require "json"
  require "open-uri"
  
  def editor
    
    #待修改参数，从数据库中读取.json文件，取代直接赋值的方式
    @json = File.read('./app/assets/examples/swagger.json')
    
    #待修改参数，从数据库中读取.json文件，取代直接赋值的方式
    @parsed_swagger = SwaggerParser::FileParser.parse("./app/assets/examples/swagger.json")   
    
    #这个方法有一个全局对象@parsed_swagger，想办法在页面中展示这个对象
    
    #测试并且接收返回的参数，目前uri还是直接指定，需要改为接收页面返回的参数
    @data = URI.parse("https://api.instagram.com/v1/media/1243167573420321701/likes?access_token=2027730041.7fbdb00.bee5dd2903584453a399a93d93a5c82d").read

  end


	#test按钮应该直接调用下面这个方法！将@data放到下面来
	def test
	
	end
	
end

