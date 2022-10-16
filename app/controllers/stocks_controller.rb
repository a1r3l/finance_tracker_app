class StocksController < ApplicationController
    def search

        if params[:stock].blank?
            flash[:alert] = "Please enter a symbol to search."
            redirect_to my_portfolio_path
        else
            @stock = Stock.new_lookup(params[:stock])
            if @stock
                render 'users/my_portfolio'
            else
                flash[:alert] = "Please enter a valid symbol to search."
                redirect_to my_portfolio_path
            end
        end
    end
end