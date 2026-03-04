class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    resource = User.find_by(username: params[:user][:username])

    if resource
      # Génération du token
      raw_token, enc_token = Devise.token_generator.generate(User, :reset_password_token)
      resource.update_columns(
        reset_password_token: enc_token,
        reset_password_sent_at: Time.current
      )

      # Redirige directement vers la page de changement de mot de passe
      redirect_to edit_user_password_path(reset_password_token: raw_token)
    else
      flash[:alert] = "Utilisateur introuvable"
      redirect_to new_user_password_path
    end
  end
end
