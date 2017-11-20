require "rails_helper"

RSpec.describe ToursController do
  describe "GET index" do
    before do
      @match = (0..4).map do |i|
        tour = FactoryBot.build :tour, name: "test#{i}"
        tour.save!
        tour
      end
      @not_match = FactoryBot.build :tour, name: "nope"
      @not_match.save
    end

    context "when search with tour name" do
      before{get :index, params: {q: {name_cont: "test"}}}
      it "return all tour match" do
        expect(assigns(:tours)).to match_array(@match)
      end
      it "doesn't include tour that are not match" do
        expect(assigns(:tours)).not_to include(@not_match)
      end
    end
  end
end
