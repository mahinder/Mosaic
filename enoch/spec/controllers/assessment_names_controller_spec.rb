require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AssessmentNamesController do

  # This should return the minimal set of attributes required to create a valid
  # AssessmentName. As you add validations to AssessmentName, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all assessment_names as @assessment_names" do
      assessment_name = AssessmentName.create! valid_attributes
      get :index
      assigns(:assessment_names).should eq([assessment_name])
    end
  end

  describe "GET show" do
    it "assigns the requested assessment_name as @assessment_name" do
      assessment_name = AssessmentName.create! valid_attributes
      get :show, :id => assessment_name.id
      assigns(:assessment_name).should eq(assessment_name)
    end
  end

  describe "GET new" do
    it "assigns a new assessment_name as @assessment_name" do
      get :new
      assigns(:assessment_name).should be_a_new(AssessmentName)
    end
  end

  describe "GET edit" do
    it "assigns the requested assessment_name as @assessment_name" do
      assessment_name = AssessmentName.create! valid_attributes
      get :edit, :id => assessment_name.id
      assigns(:assessment_name).should eq(assessment_name)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AssessmentName" do
        expect {
          post :create, :assessment_name => valid_attributes
        }.to change(AssessmentName, :count).by(1)
      end

      it "assigns a newly created assessment_name as @assessment_name" do
        post :create, :assessment_name => valid_attributes
        assigns(:assessment_name).should be_a(AssessmentName)
        assigns(:assessment_name).should be_persisted
      end

      it "redirects to the created assessment_name" do
        post :create, :assessment_name => valid_attributes
        response.should redirect_to(AssessmentName.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved assessment_name as @assessment_name" do
        # Trigger the behavior that occurs when invalid params are submitted
        AssessmentName.any_instance.stub(:save).and_return(false)
        post :create, :assessment_name => {}
        assigns(:assessment_name).should be_a_new(AssessmentName)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AssessmentName.any_instance.stub(:save).and_return(false)
        post :create, :assessment_name => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested assessment_name" do
        assessment_name = AssessmentName.create! valid_attributes
        # Assuming there are no other assessment_names in the database, this
        # specifies that the AssessmentName created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AssessmentName.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => assessment_name.id, :assessment_name => {'these' => 'params'}
      end

      it "assigns the requested assessment_name as @assessment_name" do
        assessment_name = AssessmentName.create! valid_attributes
        put :update, :id => assessment_name.id, :assessment_name => valid_attributes
        assigns(:assessment_name).should eq(assessment_name)
      end

      it "redirects to the assessment_name" do
        assessment_name = AssessmentName.create! valid_attributes
        put :update, :id => assessment_name.id, :assessment_name => valid_attributes
        response.should redirect_to(assessment_name)
      end
    end

    describe "with invalid params" do
      it "assigns the assessment_name as @assessment_name" do
        assessment_name = AssessmentName.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AssessmentName.any_instance.stub(:save).and_return(false)
        put :update, :id => assessment_name.id, :assessment_name => {}
        assigns(:assessment_name).should eq(assessment_name)
      end

      it "re-renders the 'edit' template" do
        assessment_name = AssessmentName.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AssessmentName.any_instance.stub(:save).and_return(false)
        put :update, :id => assessment_name.id, :assessment_name => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested assessment_name" do
      assessment_name = AssessmentName.create! valid_attributes
      expect {
        delete :destroy, :id => assessment_name.id
      }.to change(AssessmentName, :count).by(-1)
    end

    it "redirects to the assessment_names list" do
      assessment_name = AssessmentName.create! valid_attributes
      delete :destroy, :id => assessment_name.id
      response.should redirect_to(assessment_names_url)
    end
  end

end
