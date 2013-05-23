class SettingsController < ApplicationController
	def edit
		@settings = current_user.setting
	end

	def update
		@settings = Setting.find(params[:id])
		@settings.update_attributes(params[:setting])
		redirect_to edit_setting_path
	end
end
