# frozen_string_literal: true
class Admin::RefreshController < ApplicationController
  before_action :authenticate_user!
end
