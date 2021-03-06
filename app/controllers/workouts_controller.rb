class WorkoutsController < ApplicationController
  before_action :set_workout, only: [:show, :edit, :update, :destroy]

  # GET /workouts
  def index
    @workouts = Workout.all
    @gym = Workout.order("created_at DESC").limit(12)
    #render layout: 'two_columns'
  end

  # GET /workouts/1
  def show
    if( params[:id] )
      found = Workout.where(:id => params[:id])
      if( found.empty? )
        redirect_to workouts_url, notice: "Workout #{params[:id]} not found"
      else
        @workouts = found #.first
        @exs = found.first.exercises.sort_by{|a| a[:ordering]}
      end
    else
      redirect_to workouts_url, notice: 'Choose a workout for practice!'
    end
    # render layout: 'two_columns'
  end

  # GET /gym
  def gym
    @gym = Workout.order("created_at DESC").limit(12)
    render layout: 'two_columns'
  end

  # GET /workouts/new
  def new
    @workout = Workout.new
  end

  # GET /workouts/new_with_search/:searchkey
  def new_with_search
    @workout = Workout.new
    @exers = Exercise.find_by_sql("SELECT * FROM exercises WHERE title LIKE '%#{params[:searchkey]}%'")    
  end
  
  # GET /workouts/1/edit
  def edit
    @exs=[]
    @workout.exercises.each do |exer|
      @exs<<exer.id
    end
    # Workout's EXERCISES
    @allexs=[]
    Exercise.all.each do |exe|
      @allexs<<exe.id
    end
    #ALL EXERCISES
  end

  # POST /workouts
  def create
    @workout = Workout.new(workout_params)
    msg      = params[:workout]
    exerciseids = msg[:exercise_ids]
    
    exerciseids.each_with_index do |ex, index|
      if index > 0
      exercise = Exercise.find(ex)
      @workout.exercises<<exercise
      @workout.save
      wek = @workout.exercise_workouts.find_by_sql("select * from exercise_workouts where exercise_id=#{ex}")
      wek.last.ordering=index
      wek.last.points= msg[:points_multiplier]
      wek.last.save
      
      end
    end
        
    if @workout.save
      redirect_to @workout, notice: 'Workout was successfully created.'
    else
      render action: 'new'
    end
    

  end

  # PATCH/PUT /workouts/1
  def update
    if @workout.update(workout_params)
      redirect_to @workout, notice: 'Workout was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to workouts_url, notice: 'Workout was successfully destroyed.'
  end
  
  def practice_workout
    wid = params[:id]
    wkt = Workout.find(wid)
    ex1 = wkt.exercises.first    
    session[:current_workout]=wid
    session[:wexes]=session[:remaining_wexes]=wkt.exercises.ids[1..-1]
    redirect_to exercise_practice_path(:id => ex1.id, :wexes => wkt.exercises.ids[1..-1])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workout
      @workout = Workout.find(params[:id])
      @xp = 30
      @xptogo = 60
      @remain = 10
    end

    # Only allow a trusted parameter "white list" through.
    def workout_params
      params.require(:workout).permit(:name, :scrambled, :exercise_ids,:description, :target_group, :points_multiplier, :opening_date, :soft_deadline, :hard_deadline)
    end
end
