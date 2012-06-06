class IdeasController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  # GET /ideas
  # GET /ideas.json
  def index
    @ideas = Idea.current_ideas_for(current_user).entries
    respond_with(@ideas) do |format|
      format.json { render json: @ideas }
    end
  end

  def by_date
    @ideas = Idea.ideas_for_by_date(current_user,params[:date]).entries
    respond_with(@ideas) do |format|
      format.json { render json: @ideas }
    end
  end

  def actual
    @ideas = Idea.public_ideas_for_today.entries
    respond_with(@ideas) do |format|
      format.json { render json: @ideas }
    end
  end

  def public_by_date
    @ideas = Idea.public_ideas_by_date(params[:date])
    respond_with(@ideas) do |format|
      format.json { render json: @ideas }
    end
  end

  def winners
    @ideas = Idea.winners_by_date(Date.today.to_s)
    respond_with(@ideas) do |format|
      format.json { render json: @ideas }
    end
  end

  def winners_by_date
    @ideas = Idea.winners_by_date(params[:date])
    respond_with(@ideas) do |format|
      format.json { render json: @ideas }
    end
  end


  # GET /ideas/1
  # GET /ideas/1.json
  def show
    @idea = Idea.find(params[:id])
    respond_with(@idea) do |format|
      format.json { render json: @idea }
    end
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(params[:idea])
    @idea.user=current_user
    respond_with(@idea) do |format|
      if @idea.save
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ideas/1
  # PUT /ideas/1.json
  def update
    @idea = Idea.find(params[:id])
    respond_with(@idea) do |format|
      if @idea.update_attributes(params[:idea])
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ideas/1/publish.json
  def publish
    @idea = Idea.find(params[:id])
    respond_with(@idea) do |format|
      if @idea.publish!
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote
    @idea = Idea.find(params[:id])
    respond_with(@idea) do |format|
      if @idea.vote!(current_user)
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy
    respond_to do |format|
      format.json { render json: {status: "ok"} }
    end
  end
end
