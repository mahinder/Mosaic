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

describe TransportFeeCollectionsController do

  # This should return the minimal set of attributes required to create a valid
  # TransportFeeCollection. As you add validations to TransportFeeCollection, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all transport_fee_collections as @transport_fee_collections" do
      transport_fee_collection = TransportFeeCollection.create! valid_attributes
      get :index
      assigns(:transport_fee_collections).should eq([transport_fee_collection])
    end
  end

  describe "GET show" do
    it "assigns the requested transport_fee_collection as @transport_fee_collection" do
      transport_fee_collection = TransportFeeCollection.create! valid_attributes
      get :show, :id => transport_fee_collection.id
      assigns(:transport_fee_collection).should eq(transport_fee_collection)
    end
  end

  describe "GET new" do
    it "assigns a new transport_fee_collection as @transport_fee_collection" do
      get :new
      assigns(:transport_fee_collection).should be_a_new(TransportFeeCollection)
    end
  end

  describe "GET edit" do
    it "assigns the requested transport_fee_collection as @transport_fee_collection" do
      transport_fee_collection = TransportFeeCollection.create! valid_attributes
      get :edit, :id => transport_fee_collection.id
      assigns(:transport_fee_collection).should eq(transport_fee_collection)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TransportFeeCollection" do
        expect {
          post :create, :transport_fee_collection => valid_attributes
        }.to change(TransportFeeCollection, :count).by(1)
      end

      it "assigns a newly created transport_fee_collection as @transport_fee_collection" do
        post :create, :transport_fee_collection => valid_attributes
        assigns(:transport_fee_collection).should be_a(TransportFeeCollection)
        assigns(:transport_fee_collection).should be_persisted
      end

      it "redirects to the created transport_fee_collection" do
        post :create, :transport_fee_collection => valid_attributes
        response.should redirect_to(TransportFeeCollection.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved transport_fee_collection as @transport_fee_collection" do
        # Trigger the behavior that occurs when invalid params are submitted
        TransportFeeCollection.any_instance.stub(:save).and_return(false)
        post :create, :transport_fee_collection => {}
        assigns(:transport_fee_collection).should be_a_new(TransportFeeCollection)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TransportFeeCollection.any_instance.stub(:save).and_return(false)
        post :create, :transport_fee_collection => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested transport_fee_collection" do
        transport_fee_collection = TransportFeeCollection.create! valid_attributes
        # Assuming there are no other transport_fee_collections in the database, this
        # specifies that the TransportFeeCollection created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TransportFeeCollection.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => transport_fee_collection.id, :transport_fee_collection => {'these' => 'params'}
      end

      it "assigns the requested transport_fee_collection as @transport_fee_collection" do
        transport_fee_collection = TransportFeeCollection.create! valid_attributes
        put :update, :id => transport_fee_collection.id, :transport_fee_collection => valid_attributes
        assigns(:transport_fee_collection).should eq(transport_fee_collection)
      end

      it "redirects to the transport_fee_collection" do
        transport_fee_collection = TransportFeeCollection.create! valid_attributes
        put :update, :id => transport_fee_collection.id, :transport_fee_collection => valid_attributes
        response.should redirect_to(transport_fee_collection)
      end
    end

    describe "with invalid params" do
      it "assigns the transport_fee_collection as @transport_fee_collection" do
        transport_fee_collection = TransportFeeCollection.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TransportFeeCollection.any_instance.stub(:save).and_return(false)
        put :update, :id => transport_fee_collection.id, :transport_fee_collection => {}
        assigns(:transport_fee_collection).should eq(transport_fee_collection)
      end

      it "re-renders the 'edit' template" do
        transport_fee_collection = TransportFeeCollection.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TransportFeeCollection.any_instance.stub(:save).and_return(false)
        put :update, :id => transport_fee_collection.id, :transport_fee_collection => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested transport_fee_collection" do
      transport_fee_collection = TransportFeeCollection.create! valid_attributes
      expect {
        delete :destroy, :id => transport_fee_collection.id
      }.to change(TransportFeeCollection, :count).by(-1)
    end

    it "redirects to the transport_fee_collections list" do
      transport_fee_collection = TransportFeeCollection.create! valid_attributes
      delete :destroy, :id => transport_fee_collection.id
      response.should redirect_to(transport_fee_collections_url)
    end
  end

end
