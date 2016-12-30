class SwaggerEditorController < ApplicationController
  
  #import swagger parser
  require "swagger_parser"
  require "json"
  
  def editor
    
    #待修改参数，从数据库中读取.json文件，取代直接赋值的方式
    @json = File.read('./app/assets/examples/swagger.json')
    
    #待修改参数，从数据库中读取.json文件，取代直接赋值的方式
    @parsed_swagger = SwaggerParser::FileParser.parse("./app/assets/examples/swagger.json")   
    
    #这个方法有一个全局对象@parsed_swagger，想办法在页面中展示这个对象

  end


end

