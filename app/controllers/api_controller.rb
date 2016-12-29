class ApiController < ApplicationController
  
  def search
    if params[:api] == nil
      @apis = Api.all
    elsif params[:api][:name] == ""
      @apis = Api.all
    else
      @apis = Api.where("name like ? or description like ?", "%#{params[:api][:name]}%", "%#{params[:api][:name]}%").all
    end
  end
  
  def show
    @api = Api.find(params[:id])
    @json = File.read(@api.path.to_s)
  end
  
  def new 
    if params[:newapi] != nil
      if newapi_params[:name] != nil && newapi_params[:version] != nil && newapi_params[:json_url] != nil
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
         api_path = Rails.root.to_s+'/swagger/' + api_name+'('+api_version+').json'
         uploadjson(json_url,api_path)
         Api.create(:name => api_name, :version => api_version, :description => api_description, :logo => api_logo, :path => api_path )
         api = Api.find_by(name: api_name, version: api_version)
         redirect_to :action => 'show',:id =>  api.id
       else
        redirect_to :action => 'show',:id =>  api.id
       end
       
      else
       @message = "缺少参数"
      end
    end
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
  
=begin  
  def init
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
=end

end
