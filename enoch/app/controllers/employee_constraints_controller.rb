class EmployeeConstraintsController < ApplicationController
   before_filter :login_required,:configuration_settings_for_hr
   filter_access_to :all
   
  # GET /employee_constraints
  # GET /employee_constraints.json
  def index
    @employee_constraints = EmployeeConstraint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employee_constraints }
    end
  end

  # GET /employee_constraints/1
  # GET /employee_constraints/1.json
  def show
    @employee_constraint = EmployeeConstraint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee_constraint }
    end
  end

  # GET /employee_constraints/new
  # GET /employee_constraints/new.json
  def new
    @employee_constraint = EmployeeConstraint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee_constraint }
    end
  end

  # GET /employee_constraints/1/edit
  def edit
    @employee_constraint = EmployeeConstraint.find(params[:id])
  end

  # POST /employee_constraints
  # POST /employee_constraints.json
  def create
    @current_user= current_user
  if @current_user.privileges.map{|p| p.id}.include?(Privilege.find_by_name('HrBasics').id)
    respond_to do |format|
             format.json { render :json => {:valid => false,:notice => "Sorry you are not allowed to access that action."}}
      end
else
    @valid = "no"
    unless params[:full].nil?
      @employee_cons = EmployeeConstraint.find(:all,params[:employee_id])
        unless @employee_cons.empty?
          @employee_cons.each do |cons|
            cons.destroy
          end
        end
        params[:full].each do |con,val|
          @valid = "no"
          @employee_constraint =  EmployeeConstraint.new(val)
            if @employee_constraint.save
              @valid = "yes"
            else
              @valid =  @employee_constraint.errors
            end
        end
      else
        @valid = "yes"
        @employee_cons = EmployeeConstraint.find(:all,params[:employee_id])
        unless @employee_cons.empty?
          @employee_cons.each do |cons|
            cons.destroy
          end
        end
    end
    respond_to do |format|
      if @valid == "yes"
        format.json { render :json => {:valid => true,:notice => "constraints was successfully created."}}
      else
        format.json { render :json => {:valid => false, :errors => @valid}}
      end
    end
    end
  end

  # PUT /employee_constraints/1
  # PUT /employee_constraints/1.json
  def update
    @employee_constraint = EmployeeConstraint.find(params[:id])

    respond_to do |format|
      if @employee_constraint.update_attributes(params[:employee_constraint])
        format.html { redirect_to @employee_constraint, notice: 'Employee constraint was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @employee_constraint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_constraints/1
  # DELETE /employee_constraints/1.json
  def destroy
    @employee_constraint = EmployeeConstraint.find(params[:id])
    @employee_constraint.destroy

    respond_to do |format|
      format.html { redirect_to employee_constraints_url }
      format.json { head :ok }
    end
  end
end
