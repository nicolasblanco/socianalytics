namespace :resque
  task :test => :environment do
    Resque.enqueue(TestJob, "1234")
    Resque.enqueue(TestJob, "1234")
    Resque.enqueue(TestJob, "1234")
    Resque.enqueue(TestJob, "1234")
    Resque.enqueue(TestJob, "1234")
  end
end
