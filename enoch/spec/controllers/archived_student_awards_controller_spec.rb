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

describe ArchivedStudentAwardsController do

  # This should return the minimal set of attributes required to create a valid
  # ArchivedStudentAward. As you add validations to ArchivedStudentAward, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all archived_student_awards as @archived_student_awards" do
      archived_student_award = ArchivedStudentAward.create! valid_attributes
      get :index
      assigns(:archived_student_awards).should eq([archived_student_award])
    end
  end

  describe "GET show" do
    it "assigns the requested archived_student_award as @archived_student_award" do
      archived_student_award = ArchivedStudentAward.create! valid_attributes
      get :show, :id => archived_student_award.id
      assigns(:archived_student_award).should eq(archived_student_award)
    end
  end

  describe "GET new" do
    it "assigns a new archived_student_award as @archived_student_award" do
      get :new
      assigns(:archived_student_award).should be_a_new(ArchivedStudentAward)
    end
  end

  describe "GET edit" do
    it "assigns the requested archived_student_award as @archived_student_award" do
      archived_student_award = ArchivedStudentAward.create! valid_attributes
      get :edit, :id => archived_student_award.id
      assigns(:archived_student_award).should eq(archived_student_award)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ArchivedStudentAward" do
        expect {
          post :create, :archived_student_award => valid_attributes
        }.to change(ArchivedStudentAward, :count).by(1)
      end

      it "assigns a newly created archived_student_award as @archived_student_award" do
        post :create, :archived_student_award => valid_attributes
        assigns(:archived_student_award).should be_a(ArchivedStudentAward)
        assigns(:archived_student_award).should be_persisted
      end

      it "redirects to the created archived_student_award" do
        post :create, :archived_student_award => valid_attributes
        response.should redirect_to(ArchivedStudentAward.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved archived_student_award as @archived_student_award" do
        # Trigger the behavior that occurs when invalid params are submitted
        ArchivedStudentAward.any_instance.stub(:save).and_return(false)
        post :create, :archived_student_award => {}
        assigns(:archived_student_award).should be_a_new(ArchivedStudentAward)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ArchivedStudentAward.any_instance.stub(:save).and_return(false)
        post :create, :archived_student_award => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested archived_student_award" do
        archived_student_award = ArchivedStudentAward.create! valid_attributes
        # Assuming there are no other archived_student_awards in the database, this
        # specifies that the ArchivedStudentAward created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ArchivedStudentAward.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => archived_student_award.id, :archived_student_award => {'these' => 'params'}
      end

      it "assigns the requested archived_student_award as @archived_student_award" do
        archived_student_award = ArchivedStudentAward.create! valid_attributes
        put :update, :id => archived_student_award.id, :archived_student_award => valid_attributes
        assigns(:archived_student_award).should eq(archived_student_award)
      end

      it "redirects to the archived_student_award" do
        archived_student_award = ArchivedStudentAward.create! valid_attributes
        put :update, :id => archived_student_award.id, :archived_student_award => valid_attributes
        response.should redirect_to(archived_student_award)
      end
    end

    describe "with invalid params" do
      it "assigns the archived_student_award as @archived_student_award" do
        archived_student_award = ArchivedStudentAward.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ArchivedStudentAward.any_instance.stub(:save).and_return(false)
        put :update, :id => archived_student_award.id, :archived_student_award => {}
        assigns(:archived_student_award).should eq(archived_student_award)
      end

      it "re-renders the 'edit' template" do
        archived_student_award = ArchivedStudentAward.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ArchivedStudentAward.any_instance.stub(:save).and_return(false)
        put :update, :id => archived_student_award.id, :archived_student_award => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested archived_student_award" do
      archived_student_award = ArchivedStudentAward.create! valid_attributes
      expect {
        delete :destroy, :id => archived_student_award.id
      }.to change(ArchivedStudentAward, :count).by(-1)
    end

    it "redirects to the archived_student_awards list" do
      archived_student_award = ArchivedStudentAward.create! valid_attributes
      delete :destroy, :id => archived_student_award.id
      response.should redirect_to(archived_student_awards_url)
    end
  end

end
