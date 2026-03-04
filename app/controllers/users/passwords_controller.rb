class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    user = User.find_by(username: params[:user][:username])

    if user
      # Génération du token
      token = user.send_reset_password_instructions_internal
      # Redirige directement vers la page de changement de mot de passe
      redirect_to edit_user_password_path(reset_password_token: token)
    else
      flash[:alert] = "Utilisateur introuvable"
      redirect_to new_user_password_path
    end
  end
end
