class TasksController < ApplicationController
  before_action :authenticate_user!
  # 表示
  def index
    # allで全部出るので２４時間で絞ろう
    # resultortaskの内容を反映させること
    @falsetasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day, doneflag: false)
    @truetasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day, doneflag: true)
    @task = Task.new
  end

  # 書き込み
  def create
    @task = Task.new(params.require(:task).permit(:user_id, :title, :detail))
    if @task.save
      redirect_to :action => :index
    else
      @tasks = Task.all
      render :index
    end
  end

  # ポモドーロのサイクル（タスク→休憩）
  def action
    # 1回目の処理はget、2回目からはpost
    if request.get? then
      # グローバル変数は変えること。税金とかそういうのに使う
      # $tasks = Task.order("RANDOM()").all
      # リストの生成・並べ替え→初期タスク決定
      @tasks = Task.order("RANDOM()").where(user_id: current_user.id,created_at: Time.zone.now.all_day, doneflag: false)
      @acttask = @tasks[0]
      @task = Task.find(@acttask.id)
      @task.doneflag = true
      @task.save
      @min = 25
      @ss = 0
      @nextflag = 1
    else
    # 2回目（休憩→タスクのサイクルが続く）
    # checkflagから、休憩かタスクの判定
      checkflag = params[:flag].to_i
      case 
      # 長い休憩
      when 0 == checkflag % 9
        @min = 15
        @nextflag = 1 + checkflag
        #？ 漢字ダメなのなんで？
        @acttask = Task.new(user_id: current_user.id, title: "refresh", detail: "long", doneflag: false)
      # 小休憩
      when 0 != checkflag % 2
        @acttask = Task.new(title: "refresh", detail: "short")
        @min = 5
        @nextflag = 1 + checkflag
        # binding.pry
      else
      # タスク実行
        @tasks = Task.order("RANDOM()").where(user_id: current_user.id,created_at: Time.zone.now.all_day, doneflag: false)
        #？ tasksがヒットしないとき下記内容になる。なぜだ？
        # p @tasks
        #<ActiveRecord::Relation []>
        # => []
        # 上記が解決しないので、下記は廃止        
        # if @tasks.nil?
        #   redirect_to :action => :result
        # else
          @acttask = @tasks[0]
        # タスクが全て処理されたら結果画面へ  
        if @acttask.nil?
          redirect_to :action => :result
        else
          @task = Task.find(@acttask.id)
          @task.doneflag = true
          @task.save
          @min = 25
          @nextflag = 1 + checkflag
        end
      end
    end
  end


def result
  @tasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day,)
@task = Task.new
end

def update
    update_data = params[:task]
    # binding.pry
  update_data.each {|key, value|
    binding.pry
    unit = Task.find(:first, :conditions => ['task_id = ?', key])
    # binding.pry
    unless unit
      # データがなかった場合、indexへ
      redirect_to :action => :index
    end
    unit.doneflag = value.doneflag # フラグを設定
    unit.save
  }




  @tasks = Task.where(user_id: current_user.id,created_at: Time.zone.now.all_day,)
end


end
