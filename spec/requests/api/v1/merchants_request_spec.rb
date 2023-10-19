require 'rails_helper'

RSpec.describe "Merchants API" do 
  it "sends a list of all merchants" do 
    create_list(:merchant, 5)
    
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true )

    expect(merchants[:data].count).to eq 5
    
    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a String
      
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String
    end
  end

  it "can get one merchant by id" do 
    merchant1_id = create(:merchant).id 

    get "/api/v1/merchants/#{merchant1_id}"

    merchant = JSON.parse(response.body, symbolize_names: true)


    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a String

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a String
  end

  it "can list out all items for a merchant" do 
    merchant1 = create(:merchant)
    item1_id = create(:item, merchant_id: merchant1.id)
    item2_id = create(:item, merchant_id: merchant1.id)
    item3_id = create(:item, merchant_id: merchant1.id)
    
    merchant2 = create(:merchant)
    item4_id = create(:item, merchant_id: merchant2.id)
    item5_id = create(:item, merchant_id: merchant2.id)
    item4_id = create(:item, merchant_id: merchant2.id)

    get "/api/v1/merchants/#{merchant1.id}/items" 

    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful


    items[:data].each do |item|
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(merchant1.id)
      expect(item[:attributes][:merchant_id]).to_not eq(merchant2.id)
    end

  end
end