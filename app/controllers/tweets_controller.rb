class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: [:show, :update, :destroy]

  def index
    @tweets = current_user.tweets
    render json: @tweets, status: :ok
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user
    if @tweet.save
      render json: @tweet, status: :ok
    else
      render json: { message: @tweet.errors.full_messages}, status: :bad_request
    end 
  end

  def show
    render json: @tweet, status: :ok
  end

  def update
    authorize @tweet
    if @tweet.update(tweet_params)
      render json: @tweet, status: :ok
    else
      render json: { message: @tweet.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    authorize @tweet
    if @tweet.destroy
      render json: { message: 'Deleted successfully' }, status: :ok
    else
      render json: { message: 'Bad request' }, status: :bad_request
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:tweet)
  end
end
