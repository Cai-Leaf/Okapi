class SwaggerEditorController < ApplicationController
  
  #import swagger parser
  require "swagger_parser"
  require "json"
  require "open-uri"
  
  def editor
    
    #���޸Ĳ����������ݿ��ж�ȡ.json�ļ���ȡ��ֱ�Ӹ�ֵ�ķ�ʽ
    @json = File.read('./app/assets/examples/swagger.json')
    
    #���޸Ĳ����������ݿ��ж�ȡ.json�ļ���ȡ��ֱ�Ӹ�ֵ�ķ�ʽ
    @parsed_swagger = SwaggerParser::FileParser.parse("./app/assets/examples/swagger.json")   
    
    #���������һ��ȫ�ֶ���@parsed_swagger����취��ҳ����չʾ�������
    
    #���Բ��ҽ��շ��صĲ�����Ŀǰuri����ֱ��ָ������Ҫ��Ϊ����ҳ�淵�صĲ���
    @data = URI.parse("https://api.instagram.com/v1/media/1243167573420321701/likes?access_token=2027730041.7fbdb00.bee5dd2903584453a399a93d93a5c82d").read

  end


	#test��ťӦ��ֱ�ӵ������������������@data�ŵ�������
	def test
	
	end
	
end

