class Api::V1::MerchantItemsController < ApplicationController
  def index 

    merchant = Merchant.find(params[:merchant_id])

    item = merchant.items

    render json: ItemSerializer.new(item)


  end
end