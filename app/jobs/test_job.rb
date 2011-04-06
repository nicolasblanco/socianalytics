class TestJob
  extend Resque::Plugins::Restriction
  
  @queue = :medium
  restrict :per_minute => 2, :concurrent => 1
  
  def self.perform(id)
    puts "yeah"
  end
end
