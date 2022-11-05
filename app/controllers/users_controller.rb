class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
  
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def search_friend
    if params[:friend].blank?
      respond_to do |format|
          flash.now[:alert] = "Please enter a name to search."
          format.js { render partial: 'users/friend_result' }
      end                
    else
        @friends = User.search(params[:friend])
        @friends = current_user.exclude_from_friends(@friends)
        @friends = current_user.exclude_existent_friends(@friends)
        if @friends
            respond_to do |format|
                format.js { render partial: 'users/friend_result' }
            end
        else
            respond_to do |format|
                flash.now[:alert] = "Couldn't find user."
                format.js { render partial: 'users/friend_result' }
            end
        end
    end
  end
end
