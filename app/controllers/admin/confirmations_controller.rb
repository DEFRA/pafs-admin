# frozen_string_literal: true

module Admin
  class ConfirmationsController < ApplicationController
    before_action :authenticate_user!

    def index
      # q = params.fetch(:q, nil)
      # o = params.fetch(:o, nil)
      # d = params.fetch(:d, "asc")
      page = params.fetch(:page, "1").to_i

      # d = "asc" if d != "asc" && d != "desc"
      # @users = if q
      #            User.search(q)
      #          else
      #            User.all.includes(:areas)
      #          end
      # @users = if o && o == "area"
      #            @users.joins(:areas).merge(PafsCore::Area.order(name: d)).page(page)
      #          else
      #            @users.order(last_name: d, first_name: d).page(page)
      #          end

      # collect submissions that are the last one for a project and either have the status
      # "sent" or "failed".
      @submissions = PafsCore::AsiteSubmission.where(id: last_submission_ids)
                                              .sent_or_unsuccessful
                                              .includes(:project).order(email_sent_at: "desc", id: "desc")
                                              .page(page).per(10)
    end

    private

    def last_submission_ids
      PafsCore::AsiteSubmission.group(:project_id).maximum(:id).values
    end
  end
end
