class CreditCardController < ApplicationController

  def create
    if valid_params
        @credit_card = CreditCard.new(card_params[:number], card_params[:expiration_year], card_params[:expiration_month])
        if @credit_card.valid?
            session[:credit_card] = @credit_card
            redirect_to cart_path, notice: "Successfully added a payment method."
        else
            redirect_to cart_path, notice: "Invalid payment method."
        end
    end
  end

  # def update
  #   if valid_params
  #       @credit_card = CreditCard.new(card_params[:number], card_params[:expiration_year], card_params[:expiration_month])
  #       if @credit_card.valid?
  #           session[:credit_card] = @credit_card
  #           redirect_to cart_path, notice: "Successfully updated payment method."
  #       else
  #           redirect_to cart_path, notice: "Invalid payment method."
  #       end
  #   end
  # end

  def destroy
    session[:credit_card] = nil
    redirect_to cart_path, notice: "Please enter a new payment method."
  end

  private
  def valid_params
    !card_params[:number].nil? && !card_params[:expiration_year].nil? && !card_params[:expiration_month].nil?
  end

  def card_params
    params.require(:credit_card).permit(:number, :expiration_year, :expiration_month)
  end
end
