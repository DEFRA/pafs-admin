# frozen_string_literal: true

module Admin
  class RefreshController < ApplicationController
    before_action :authenticate_user!
  end
end
