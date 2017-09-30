class TasksController < ApplicationController
  	  # 表示
      def index
        @tasks = Task.all
        @task = Task.new
      end

  # 書き込み
  def create
    @task = Task.new(params.require(:task).permit(:title, :detail))
    if @task.save
      redirect_to :action => :index
    else
      @tasks = Task.all
      render :index
    end
  end

# 実行# ポモドーロのサイクル（リストの生成・並べ替え・配列０の実行）
def action
  # 1回目の処理
  if request.get? then
    $tasks = Task.order("RANDOM()").all
    @acttask = $tasks[0]
    @msg = "first action get"
    @min = 25
    @ss = 0
    $task_num = 0
  else
    @msg = "second action get"
    $task_num = $task_num + 1
    # @tasks = params[:name]
    @acttask = $tasks[$task_num]
    if @acttask.nil?    
      redirect_to :action => :result
    end

  end
end


def result

end


end
