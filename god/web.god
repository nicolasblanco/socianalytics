rails_env   = ENV['RAILS_ENV']  || "staging"
rails_root  = ENV['RAILS_ROOT'] || "/home/rails/www/socianalytics/current"

# Resque
God.watch do |w|
  w.env = { 'RAILS_ROOT' => rails_root,
              'RAILS_ENV'  => rails_env }

  w.name          = "resque-worker"
  w.interval      = 30.seconds
  w.start         = "cd #{rails_root} && rake environment resque:work QUEUE=high,medium,low"
  w.start_grace   = 10.seconds
  
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end
  
  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end
    
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end
  
  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end
