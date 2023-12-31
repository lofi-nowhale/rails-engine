require 'rails_helper'

describe "Items API" do 
  it "sends a list of all items" do 
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    create_list(:item, 4, merchant_id: merchant1.id )
    create_list(:item, 6, merchant_id: merchant2.id )


    get "/api/v1/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 10
    # require 'pry';binding.pry

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a String

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String
      
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String
      
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float
      
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
    end

  end
  it "can get one item by id" do 
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant1.id)

    item4 = create(:item, merchant_id: merchant2.id)
    item5 = create(:item, merchant_id: merchant2.id)
    item4 = create(:item, merchant_id: merchant2.id)

    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a String

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a String

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a String

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a Float

    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_an Integer
  end

  it "can create a new item"  do 
    merchant1 = create(:merchant)

    item_params = ({
      name: 'Mug',
      description: 'vessel to hold ur bevies',
      unit_price: 10.5,
      merchant_id: merchant1.id
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    new_item = Item.last

    expect(response).to be_successful

    expect(new_item.name).to eq(item_params[:name])
    expect(new_item.description).to eq(item_params[:description])
    expect(new_item.unit_price).to eq(item_params[:unit_price])
    expect(new_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an item" do 
    merchant1 = create(:merchant)
    item = create(:item, merchant_id: merchant1.id)
    previous_name = Item.last.name
    item_params = ({ 
      name: "New Item Name",
      # description: item.description, 
      # unit_price: item.unit_price, 
      merchant_id: merchant1.id 
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
    
    updated_item = Item.find_by(id: item.id)

    expect(response).to be_successful

    expect(updated_item.name).to_not eq(previous_name)
    expect(updated_item.name).to eq("New Item Name") 
  end

  it "delivers a 4xx code when the item cannot update" do 
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_params = ({
      unit_price: nil
    })

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to_not be_successful

  end

  it "can destroy an item" do 
    merchant1 = create(:merchant)
    item = create(:item, merchant_id: merchant1.id)

    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end