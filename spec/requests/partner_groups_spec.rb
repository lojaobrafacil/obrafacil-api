require "rails_helper"

RSpec.describe "PartnerGroup API", type: :request do
  before do
    @api = create(:api)
    @partner_groups = create_list(:partner_group, 5)
    @partner_group = @partner_groups.first
    @partner_group_id = @partner_group.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /partner_groups" do
    before do
      get "/partner_groups#{@auth_data}", params: {}
    end
    it "return 5 partner_groups from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /partner_groups/:id" do
    before do
      get "/partner_groups/#{@partner_group_id}#{@auth_data}", params: {}
    end
    it "return partner_group from database" do
      expect(json_body.size).to eq(Api::PartnerGroupSerializer.new(@partner_group).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /partner_groups" do
    before do
      post "/partner_groups#{@auth_data}", params: partner_group_params
    end

    context "when the request params are valid" do
      let(:partner_group_params) { attributes_for(:partner_group) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created partner_group" do
        expect(json_body[:name]).to eq(partner_group_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:partner_group_params) { {name: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /partner_groups/:id" do
    before do
      put "/partner_groups/#{@partner_group_id}#{@auth_data}", params: partner_group_params
    end

    context "when the request params are valid" do
      let(:partner_group_params) { {name: "Grupo"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated partner_group" do
        expect(json_body[:name]).to eq(partner_group_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:partner_group_params) { {name: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /partner_groups/:id" do
    before do
      delete "/partner_groups/#{@partner_group_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(PartnerGroup.find_by(id: @partner_group_id)).to be_nil
    end
  end
end
