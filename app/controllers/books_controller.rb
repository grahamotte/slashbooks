class BooksController < ApplicationController
  before_action :clear_flashes
  before_action -> { @hide_props = true }, except: [:index, :create]
  before_action :flash_when_no_sub_found, only: [:edit, :destroy, :more]

  def index
  end

  def create
    if email_param.present? && epub_param.present?
      book = EpubImporter.call(epub_param)
      sub = Subscription.create!(book: book, email: email_param)
      BookMailer.part_email(sub).deliver_later
      flash[:success] = "Success! #{email_param} should receive the first part soon!"
    else
      flash[:error] = "Looks like something is missing..."
    end
  rescue StandardError => e
    flash_unknown_error
    Rollbar.error(e)
  ensure
    render :index
  end

  def edit
  end

  def destroy
    sub.destroy!
    flash[:success] = 'Subscription has been deleted, you\'ll no longer receive emails.'
    render :blank
  end

  def more
    BookMailer.part_email(sub).deliver_later
    flash[:success] = 'Done! Go check your e-mail!'
    render :blank
  end

  private

  def flash_when_no_sub_found
    if sub.blank?
      flash[:error] = 'No subscription found.'
      render :blank
      return
    end
  end

  def flash_unknown_error
    flash[:error] = "Crap! Something went wrong!"
  end

  def clear_flashes
    flash[:error] = nil
    flash[:success] = nil
  end

  def sub
    @sub ||= Subscription.find_by(uuid: params.require(:id))
  end

  def email_param
    params.require(:book).require(:email)
  end

  def epub_param
    f = params.require(:book).require(:epub)
    f.rewind
    f
  end
end
