require 'pdg_data_receiver'

class ResqueTask < ProdigyDataReceiver::UpdateTask
  @queue = 'test-queue'
  def self.perform_data_event(params)
    puts params
  end

end
