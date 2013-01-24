# encoding: utf-8

ActiveAdmin.register Poll do
  menu label: "Опросы"

  controller do
    def create
      @poll = Poll.new(params[:poll])
      if @poll.save
        redirect_to edit_admin_poll_path(@poll)
      else
        render 'edit'
      end
    end
  end

  form partial: 'polls/admin_form'
end