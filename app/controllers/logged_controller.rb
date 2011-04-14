# encoding: utf-8
class LoggedController < ApplicationController
  before_filter :authenticate_user!
end
