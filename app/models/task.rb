class Task < ApplicationRecord
	belongs_to :user

# タスク追加（modelとcontrollerのやりとりの練習）
	def self.create(task_params)
		@task = Task.new(task_params)
		if @task.save
			return;
		else
			@tasks = Task.all
		end
	end

# 未実行タスクのランダム選択 + 実施済みフラグを立てる
  def self.taskAct(user_id)
  	  tasks = Task.order("RANDOM()").where(user_id: user_id,created_at: Time.zone.now.all_day, doneflag: false)
      acttask = tasks[0]
      return acttask if acttask.nil? 
      task = Task.find(acttask.id)
      task.doneflag = true
      task.save
      return acttask
  end

# flagによる次のサイクル判定
	def self.nextTaskCheck(user_id,checkflag)
	case 
	      # 長い休憩
	  when 0 == checkflag % 9
	  	return breakLong(user_id,checkflag)
	      # 小休憩
	  when 0 != checkflag % 2
	  	return breakShort(user_id,checkflag)
	      # タスク実行
	  else
	  	return actTimer(user_id,checkflag)
	end
	end


# サイクル判定後の[分,フラグ,次のタスク]の実施値を返す
	def self.actTimer(user_id,checkflag)
		nextflag = 1 + checkflag
		acttask = taskAct(user_id)
		return [25,nextflag,acttask]
	end

	def self.breakShort(user_id,checkflag)
		nextflag = 1 + checkflag
		acttask = Task.new(title: "refresh", detail: "short")
		return [5,nextflag,acttask]
	end

	def self.breakLong(user_id,checkflag)
		nextflag = 1 + checkflag
        acttask = Task.new(title: "refresh", detail: "long")
		return [15,nextflag,acttask]      
	end



end
