class BeehiivSubscribeJob < ApplicationJob
  queue_as :default

  def perform(waiting_list_id)
    waiting_list = WaitingList.find_by(id: waiting_list_id)
    return unless waiting_list
    Beehiiv::SubscribeService.subscribe(waiting_list)
  end
end
