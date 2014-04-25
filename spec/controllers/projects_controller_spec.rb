require 'spec_helper'

describe ProjectsController do
  context "when attempting to access a resource that no longer exists" do
    before do
      get :show, id: 'resource-that-no-longer-exists'
    end

    it "redirects to the Projects page" do
      expect(response).to redirect_to projects_path
    end

    it "alerts with the appropriate message" do
      expect(flash[:alert]).to eql "The project you were looking for could not be found."
    end
  end
end
