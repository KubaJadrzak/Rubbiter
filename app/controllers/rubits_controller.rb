class RubitsController < ApplicationController
    def index
        @rubits = Rubit.includes(:user).order(created_at: :desc)
        @rubit = Rubit.new
      end
end
