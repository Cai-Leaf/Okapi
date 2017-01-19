class ApiController < ApplicationController
  
  
  #import
  require "swagger_parser"
  require "json"
  require "open-uri"
  
  skip_before_filter :verify_authenticity_token, :only => [:new]
  
  def search
    @cur_page = "API搜索"
    @num = 0
    if params[:searchvalue] == nil
      @apis = Api.all
      @cur_searchvalue = ""
    elsif params[:searchvalue] == ""
      @apis = Api.all
      @cur_searchvalue = ""
    else
      @apis = Api.where("name like ? or description like ?", "%#{params[:searchvalue]}%", "%#{params[:searchvalue]}%").all
      @cur_searchvalue = params[:searchvalue]
      @num = @apis.size
    end
  end
  
  def show
    @cur_page = "API展示"
    @api = Api.find(params[:id])
    @json = File.read(@api.path.to_s)
    
    
    #################added by YF######################################

    #待修改参数，从数据库中读取.json文件，取代直接赋值的方式
    @parsed_swagger = SwaggerParser::FileParser.parse(@api.path.to_s)   
    
    
    @schemes = @parsed_swagger.schemes  #http or https
    @host = @parsed_swagger.host
    @basepath = @parsed_swagger.base_path
    
    
    @paths = Array.new
    hash_parameters = Array.new
    parameter_hash = Hash.new
    hash = Hash.new

    #用三层循环将json装入一个二维哈希中
    #每个路径
    @parsed_swagger.paths.each do |path|

      #每个路径中的方法
      path[1].operations.each do |operation| 

        #每个方法中的参数,parameter[0]是一个哈希
        operation.parameters.each do |parameter|  
          parameter_hash = {:param_name =>parameter[0]['name'], :required =>parameter[0]['required']}   
          hash_parameters.push(parameter_hash)
        end
        #URL链接的格式：schemes + // + host + / + basepath + path(with argument)
        url = ''
        #使用正则表达式对url进行处理，使之符合标准格式
        pattern = /http|https/
        url << pattern.match(@schemes.to_s).to_s << '://' << @host.to_s  << @basepath.to_s << path[0]
        hash = {:path_name =>path[0], :action =>operation.http_method, :description =>operation.description, :operationid =>operation.operation_id, :parameters =>hash_parameters, 
        :test_url => url }
        @paths.push(hash)
      end
    end
		############## YF's part over ################################################    
    
  end
  
  def new
    @cur_page = "API上传"
    @message = "true"
    if params[:newapi] != nil
      if newapi_params[:name] != "" && newapi_params[:version] != "" && newapi_params[:json_url] != nil
       api_name = newapi_params[:name]
       api_version = newapi_params[:version]
       api = Api.find_by(name: api_name, version: api_version)
       
       if api == nil
         api_description = newapi_params[:description]
         if api_description == ""
           api_description = "No Description"
         end
       
         logo_url = newapi_params[:logo_url]
         logo_name = api_name + '_' + api_version + '.png'
         if logo_url != nil
            api_logo = uploadlogo(logo_url,logo_name)
         else
            api_logo = "no_logo.png"
         end
       
         json_url = newapi_params[:json_url]
         str = json_url.original_filename
         len = str.length
         
         if str[len-5..len] == '.json'
           api_path = Rails.root.to_s+'/swagger/' + api_name+'('+api_version+').json'
           uploadjson(json_url,api_path)
           Api.create(:name => api_name, :version => api_version, :description => api_description, :logo => api_logo, :path => api_path )
           api = Api.find_by(name: api_name, version: api_version)
           redirect_to :action => 'show',:id =>  api.id
         else
           @message = "API文档不符合要求"
         end
         
       else
        @message = "上传的API文档已存在"
       end
       
      else
       @message = "缺少参数"
      end
    end
  end
  
   def init
       Api.destroy_all
       
       json = File.read(Rails.root.to_s+'/app/assets/list.json')
       obj = JSON.parse(json)
       obj.each{ |key,value|  
          aname = key 
          value['versions'].each{ |k2, v2|
            aversion = k2
            temp = v2['info']
       
            if temp['description'] != nil
               adescription = temp['description']
            else
               adescription = "No Description"
            end
       
            if temp['x-logo'] != nil
               alogo = temp['x-logo']['url'].to_s
               alogo = alogo[36..alogo.length]
            else
               alogo = "no_logo.png"
            end
       
            apath = Rails.root.to_s+'/swagger/' + aname+'('+aversion+').json'
            apath = apath.sub(':','.')
       
            if !Api.find_by(name: aname,version: aversion)
               Api.create(:name => aname, :version => aversion, :description => adescription, :logo => alogo, :path => apath )
            end
          }
       }
       
  end

  
  protected
  def uploadlogo(file,filename)
    if !file.original_filename.empty?
      File.open("#{Rails.root}/app/assets/images/#{filename}", "wb") do |f|
        f.write(file.read)
      end
      return filename
    else
      return "no_logo.png"
    end
  end
 
  protected
  def uploadjson(file,filepath)
    if !file.original_filename.empty?
      File.open("#{filepath}", "wb") do |f|
        f.write(file.read)
      end
    end
  end

  private 
	def newapi_params
		params.require(:newapi).permit(:name, :description, :logo_url, :version, :json_url)
	end

end
