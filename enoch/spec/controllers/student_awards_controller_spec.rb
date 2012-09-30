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

describe StudentAwardsController do

  # This should return the minimal set of attributes required to create a valid
  # StudentAward. As you add validations to StudentAward, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all student_awards as @student_awards" do
      student_award = StudentAward.create! valid_attributes
      get :index
      assigns(:student_awards).should eq([student_award])
    end
  end

  describe "GET show" do
    it "assigns the requested student_award as @student_award" do
      student_award = StudentAward.create! valid_attributes
      get :show, :id => student_award.id
      assigns(:student_award).should eq(student_award)
    end
  end

  describe "GET new" do
    it "assigns a new student_award as @student_award" do
      get :new
      assigns(:student_award).should be_a_new(StudentAward)
    end
  end

  describe "GET edit" do
    it "assigns the requested student_award as @student_award" do
      student_award = StudentAward.create! valid_attributes
      get :edit, :id => student_award.id
      assigns(:student_award).should eq(student_award)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new StudentAward" do
        expect {
          post :create, :student_award => valid_attributes
        }.to change(StudentAward, :count).by(1)
      end

      it "assigns a newly created student_award as @student_award" do
        post :create, :student_award => valid_attributes
        assigns(:student_award).should be_a(StudentAward)
        assigns(:student_award).should be_persisted
      end

      it "redirects to the created student_award" do
        post :create, :student_award => valid_attributes
        response.should redirect_to(StudentAward.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved student_award as @student_award" do
        # Trigger the behavior that occurs when invalid params are submitted
        StudentAward.any_instance.stub(:save).and_return(false)
        post :create, :student_award => {}
        assigns(:student_award).should be_a_new(StudentAward)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        StudentAward.any_instance.stub(:save).and_return(false)
        post :create, :student_award => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested student_award" do
        student_award = StudentAward.create! valid_attributes
        # Assuming there are no other student_awards in the database, this
        # specifies that the StudentAward created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        StudentAward.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => student_award.id, :student_award => {'these' => 'params'}
      end

      it "assigns the requested student_award as @student_award" do
        student_award = StudentAward.create! valid_attributes
        put :update, :id => student_award.id, :student_award => valid_attributes
        assigns(:student_award).should eq(student_award)
      end

      it "redirects to the student_award" do
        student_award = StudentAward.create! valid_attributes
        put :update, :id => student_award.id, :student_award => valid_attributes
        response.should redirect_to(student_award)
      end
    end

    describe "with invalid params" do
      it "assigns the student_award as @student_award" do
        student_award = StudentAward.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        StudentAward.any_instance.stub(:save).and_return(false)
        put :update, :id => student_award.id, :student_award => {}
        assigns(:student_award).should eq(student_award)
      end

      it "re-renders the 'edit' template" do
        student_award = StudentAward.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        StudentAward.any_instance.stub(:save).and_return(false)
        put :update, :id => student_award.id, :student_award => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student_award" do
      student_award = StudentAward.create! valid_attributes
      expect {
        delete :destroy, :id => student_award.id
      }.to change(StudentAward, :count).by(-1)
    end

    it "redirects to the student_awards list" do
      student_award = StudentAward.create! valid_attributes
      delete :destroy, :id => student_award.id
      response.should redirect_to(student_awards_url)
    end
  end

end
