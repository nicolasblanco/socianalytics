class SignUpsController < ApplicationController
  def show
    @user = User.new
  end

  def create
    redirect_to sign_up_path and return unless params[:promo_code].present? && params[:promo_code].upcase == "MCFLY"

    @user = User.new(params[:user])

    if @user.save
      @user.authorized = true
      sign_in(:user, @user)
      redirect_to dashboard_root_path, :notice => "Bienvenue sur Socianalytics! Veuillez désormais lier votre compte aux réseaux sociaux dans votre profil pour pouvoir profiter des statistiques !"
    else
      render "show"
    end
  end
end
