require "appsignal"

# AppSignal Setup
Appsignal.config = Appsignal::Config.new(
  File.expand_path(File.dirname(__FILE__)),
  "production", # Has to be defined in config/appsignal.yml
)
Appsignal.start_logger
Appsignal.start

class Monitor
  def initialize
  end

  def perform
    ActiveSupport::Notifications.instrument('perform.do_stuff', {}) do
      puts 'doing stuff'
      sleep 2
    end
  end
end

loop do
  begin
    Appsignal.monitor_transaction('perform_job.monitor', {:class => 'Monitor', :method => 'loop'}) do
      Monitor.new.perform
    end
  rescue
    # ignored
  end
  sleep 5
end
