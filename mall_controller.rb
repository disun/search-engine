class MallController < ApplicationController
 
  def index
    @tenants = Tenant.find(:all, :order => "mall_id" )
    
    respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @tenants } 
    end   
  end 
  def list
    @tenants = Tenant.find(:all, :order => "mall_id" )
    
    respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @tenants } 
    end   
  end 
  
  def state
    @tenants = Tenant.order("mall_id").where("state=?", params[:id]).all
    @state = params[:id]
    
    respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @tenants } 
    end   
  end
  
  def allstates
    @tenants = Tenant.find(:all, :order => "state,mall_id" )
    
    respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @tenants } 
    end   
  end 

  def show
    # this is strange, but we need to do a where, because mall_id is not a primary key, then we need to find again
    # on the primary key to use the nested model relationships.  Anyway, it works.
    # I think this is because Tenant.where(...) could be a collection, but find on id guarantees one row.
    # @tenant_mall = Tenant.where("mall_id= ?", params[:id])
    @tenant = Tenant.find(params[:id])  
    if params[:page].nil?
      @tenantpages = @tenant.tenantpages.where("page_name like 'Home'").all
    elsif
      @tenantpages = @tenant.tenantpages.where( "page_name Like ?", params[:page]).all
    end
    
    respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @tenant }
    end
  end 
  
  def search
    if params[:name].present?     
    @name = params[:name]  
    sql= "SELECT * FROM tenants WHERE name LIKE '%"+@name+"%'"
    @tenants=Tenant.find_by_sql(sql)
    
    elsif params[:search].present?
        if !params[:Distance].nil?
        if !params[:Distance].empty? 
          @Distance = params[:Distance] 
        end
      end
    @tenantlocations = Tenantlocation.near(params[:search], @Distance, :order => :distance)
    @ary = Array.new 
    @tenantlocations.each do|t|
     @ary.push(t.tenant_id)
    end
    @tids = String.new
    @ary.each {|a|
      @tids<<a.to_s
       @tids<<","
    }
    @tid=@tids[0,@tids.length-1]
    sql="SELECT * FROM tenants
     WHERE id IN ("+@tid+")"
     @tenants=Tenant.find_by_sql(sql) 
  else
    @tenants = Tenant.find(:all, :order => "mall_id" ) 
  end
  
  
    respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @tenants} 
    end   
  end   
  def about
    respond_to do |format|
      format.html
    end
  end
 
end