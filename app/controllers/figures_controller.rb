class FiguresController < ApplicationController

  get '/figures' do #index page
    @figures = Figure.all
    erb :'figures/index'
  end

  post '/figures' do
    @figure = Figure.create(name: params[:figure][:name])
    if params[:figure][:landmark_ids]
      @figure.landmarks << find_figure_landmarks(params[:figure][:landmark_ids])
    elsif params[:landmark][:name]
      @figure.landmarks << Landmark.create(params[:landmark])
    end

    if params[:figure][:title_ids]
      @figure.titles << find_figure_titles(params[:figure][:title_ids])
    elsif params[:title][:name]
      @figure.titles << Title.create(params[:title])
    end

    @figure.save
    redirect "/figures/#{@figure.id}"
  end

  get '/figures/new' do #create new figure
    erb :'figures/new'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find_by_id(params[:id])
    erb :'/figures/edit'
  end

  patch '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    if !params[:figure][:name].empty?
      @figure.name = params[:figure][:name]
    end

    @figure.landmarks.clear
    if params[:figure][:landmark_ids]
      @figure.landmarks << find_figure_landmarks(params[:figure][:landmark_ids])
    elsif params[:landmark][:name]
      @figure.landmarks << Landmark.create(params[:landmark])
    end

    @figure.titles.clear
    if params[:figure][:title_ids]
      @figure.titles << find_figure_titles(params[:figure][:title_ids])
    elsif params[:title][:name]
      @figure.titles << Title.create(params[:title])
    end

    @figure.save
    redirect "/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    erb :'figures/show'
  end

  #helper methods
    def find_figure_titles(title_ids) #array
      title_ids.collect {|title_id| Title.find_by_id(title_id)}
    end

    def find_figure_landmarks(landmark_ids) #array
      landmark_ids.collect {|landmark_id| Landmark.find_by_id(landmark_id)}
    end

end
