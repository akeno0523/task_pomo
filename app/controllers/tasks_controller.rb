class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
    @falsetasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day, doneflag: false)
    @truetasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day, doneflag: true)
    @task = Task.new
  end

  def create
    Task.create(task_params)
    redirect_to :action => :index
  end


  # ポモドーロのサイクル（タスク→休憩）
  def action
    if request.get? then  # 1回目の処理はget、2回目からはpost
      @min, @nextflag, @acttask = Task.actTimer(current_user.id, 0)
      redirect_to :action => :index if @acttask.id.nil? 
    else  # 2回目（休憩→タスクのサイクルが続く）
    checkflag = params[:flag].to_i   # checkflagから、休憩かタスクの判定
    @min, @nextflag, @acttask = Task.nextTaskCheck(current_user.id,checkflag)
    redirect_to :action => :result if @acttask.nil? 
    end
  end

  def result
    @tasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day,)
    @task = Task.new
  end

  def updateflag
    update_data = params[:task]
    update_data.each {|key, value|
      unit = Task.where(id: key)
      unless unit  # データがなかった場合、indexへ
        redirect_to :action => :index
      end
      if value == "true"
        unit[0].doneflag = true # フラグを設定
        unit[0].save
      else
        unit[0].doneflag = false # フラグを設定
        unit[0].save
      end
    }
    @tasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day,)
    redirect_to :action => :result
  end

  def trend
    # @chart_data = {}
    # ['日', '月', '火', '水', '木', '金', '土'].each_with_index do |dow, i|
    # # sqlite3は、extractをサポートしていない
    # # count_by_dow = Task.where(["extract(dow from created_at AT TIME ZONE 'UTC' AT TIME ZONE 'JST') = ? and user_id = ?", i,current_user.id]).count
    # count_by_dow = Task.where(["strftime('%w', updated_at) = ? and user_id = ?", i,current_user.id]).count
    # # binding.pry
    # @chart_data.store(dow,count_by_dow)
    # end
    # ---------
    @chart_data = {}
    @dowCountNum = 0
    @userAllTasks = Task.where(user_id: current_user.id)
    # @userAllTasks.updated_at = @userAllTasks.updated_at.strftime('%w')
    ['日', '月', '火', '水', '木', '金', '土'].each_with_index do |dow, i|
    @dowCountNum = 0
      @userAllTasks.each do |task|
        if task.updated_at.strftime('%w').to_i == i
          @dowCountNum = @dowCountNum + 1
          @chart_data.store(dow,@dowCountNum)
        end
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    obj = Task.find(params[:id])
    obj.update(task_params)
    redirect_to :action => :index
  end

  def destroy
    obj = Task.find(params[:id])
    obj.destroy
    redirect_to :action => :index
  end

  private
  def task_params
    params.require(:task).permit(:title, :detail, :user_id)
  end

  def correct_user
    task = Task.find(params[:id])
    if current_user.id != task.user.id
      redirect_to root_path
    end
  end

end
