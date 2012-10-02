class LunchesController < ApplicationController
  
  # GET /lunches/template.html
  def template
    render :text => File.read(Rails.root.join('app/views/lunches/_template.html'))
  end

  # GET /lunches
  # GET /lunches.json
  def index
    @lunches = Lunch.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @lunches.to_json(:include => :people) }
    end
  end

  # GET /lunches/1
  # GET /lunches/1.json
  def show
    @lunch = Lunch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lunch }
    end
  end

  # GET /lunches/new
  # GET /lunches/new.json
  def new
    @lunch = Lunch.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lunch }
    end
  end

  # GET /lunches/1/edit
  def edit
    @lunch = Lunch.find(params[:id])
  end

  # POST /lunches
  # POST /lunches.json
  def create
    @lunch = Lunch.new(params[:lunch])

    respond_to do |format|
      if @lunch.save
        ESHQ.send :channel => "lunch-notifications", :data => {:lunch => @lunch, :type => 'new'}.to_json, :type => "message"
        format.html { redirect_to @lunch, notice: 'Lunch was successfully created.' }
        format.json { render json: @lunch, status: :created, location: @lunch }
      else
        format.html { render action: "new" }
        format.json { render json: @lunch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lunches/1
  # PUT /lunches/1.json
  def update
    @lunch = Lunch.find(params[:id])

    respond_to do |format|
      if @lunch.update_attributes(params[:lunch])
        format.html { redirect_to @lunch, notice: 'Lunch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lunch.errors, status: :unprocessable_entity }
      end
    end
  end

  #POST /lunches/1/add
  def add
    @lunch = Lunch.find(params[:id])
    @person = Person.find_or_create_by_fb_id_and_name(params[:user])
    @lunch.people << @person
    @lunch.save
    ESHQ.send :channel => "lunch-notifications", :data => {:lunch => @lunch, :person => @person, :type => 'add'}.to_json, :type => "message"
    render :nothing => true
  end

  #POST /lunches/1/remove
  def remove
    @lunch = Lunch.find(params[:id])
    @person = Person.find_by_fb_id(params[:user][:fb_id])
    @lunch.people.delete(@person)
    @lunch.save
    render :nothing => true
  end  

  # DELETE /lunches/1
  # DELETE /lunches/1.json
  def destroy
    @lunch = Lunch.find(params[:id])
    @lunch.destroy

    respond_to do |format|
      format.html { redirect_to lunches_url }
      format.json { head :no_content }
    end
  end
end
