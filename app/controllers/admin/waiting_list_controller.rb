require "csv"

class Admin::WaitingListController < ApplicationController
  before_action :authenticate_admin!
  layout "admin"

  def index
    respond_to do |format|
      format.html do
        @waiting_lists = WaitingList.order(created_at: :desc).page(params[:page]).per(20)
      end

      format.csv do
        send_data waiting_list_csv,
                  filename: "waiting_list-#{Time.zone.now.strftime('%Y%m%d-%H%M%S')}.csv",
                  type: "text/csv; charset=utf-8",
                  disposition: :attachment
      end
    end
  end

  def show
    @waiting_list = WaitingList.find(params[:id])
  end

  def sync_beehiiv
    @waiting_list = WaitingList.find(params[:id])
    result = Beehiiv::SubscribeService.subscribe(@waiting_list)
    if result.success?
      flash[:notice] = "Beehiiv sync successful."
    else
      flash[:alert] = "Beehiiv sync failed: #{@waiting_list.beehiiv_sync_error || 'Unknown error'}"
    end
    redirect_to admin_waiting_list_index_path
  end

  def resend_welcome_email
    @waiting_list = WaitingList.find(params[:id])

    begin
      UserMailer.with(email: @waiting_list.email).waiting_list_welcome_email.deliver_now
      @waiting_list.update(
        send_welcome_email_is_success: true,
        send_welcome_email_at: Time.current
      )
      flash[:notice] = "Welcome email sent successfully."
    rescue => e
      Rails.logger.error("Failed to resend welcome email for WaitingList##{@waiting_list.id}: #{e.message}")
      @waiting_list.update(
        send_welcome_email_is_success: false,
        send_welcome_email_at: Time.current
      )
      flash[:alert] = "Failed to resend welcome email."
    end

    redirect_to admin_waiting_list_index_path
  end

  private

  def waiting_list_csv
    CSV.generate(headers: true) do |csv|
      csv << [
        "id",
        "email",
        "first_name",
        "last_name",
        "name",
        "subscribe_type",
        "send_welcome_email_is_success",
        "send_welcome_email_at",
        "beehiiv_sync_is_success",
        "beehiiv_synced_at",
        "beehiiv_subscriber_id",
        "beehiiv_sync_error",
        "created_at",
        "updated_at"
      ]

      WaitingList.order(created_at: :desc).each do |waiting_list|
        csv << [
          waiting_list.id,
          waiting_list.email,
          waiting_list.first_name,
          waiting_list.last_name,
          waiting_list.name,
          waiting_list.subscribe_type,
        waiting_list.send_welcome_email_is_success,
        waiting_list.send_welcome_email_at,
          waiting_list.beehiiv_sync_is_success,
          waiting_list.beehiiv_synced_at,
          waiting_list.beehiiv_subscriber_id,
          waiting_list.beehiiv_sync_error,
          waiting_list.created_at,
          waiting_list.updated_at
        ]
      end
    end
  end
end
