class SwaggerEditorController < ApplicationController
  
  #import swagger parser
  require "swagger_parser"
  require "json"
  
  def editor
    
    #���޸Ĳ����������ݿ��ж�ȡ.json�ļ���ȡ��ֱ�Ӹ�ֵ�ķ�ʽ
    @json = File.read('./app/assets/examples/swagger.json')
    
    #���޸Ĳ����������ݿ��ж�ȡ.json�ļ���ȡ��ֱ�Ӹ�ֵ�ķ�ʽ
    @parsed_swagger = SwaggerParser::FileParser.parse("./app/assets/examples/swagger.json")   
    
    #���������һ��ȫ�ֶ���@parsed_swagger����취��ҳ����չʾ�������

  end


end

