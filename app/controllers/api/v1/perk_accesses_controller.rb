module Api
  module V1
    class PerkAccessesController < ApiController
      def create
        unless params[:user_id].present? && params[:perk_id].present?
          return render 'api/v1/shared/error',
                      locals: { message: 'Invalid parameters', errors: ['User ID and Perk ID are required'] },
                      status: :unprocessable_entity
        end

        user = User.find_by(id: params[:user_id])
        unless user
          return render 'api/v1/shared/error',
                      locals: { message: 'User not found', errors: ['User does not exist'] },
                      status: :not_found
        end

        perk = Perk.find_by(id: params[:perk_id])
        unless perk
          return render 'api/v1/shared/error',
                      locals: { message: 'Perk not found', errors: ['Perk does not exist'] },
                      status: :not_found
        end

        perk_access = PerkAccess.find_or_initialize_by(user: user, perk: perk)
        if perk_access.persisted?
          return render 'api/v1/shared/error',
                      locals: { message: 'Already has access', errors: ['User already has access to this perk'] },
                      status: :unprocessable_entity
        end

        if perk_access.save
          @perk_access = perk_access
          render :create, status: :created
        else
          render 'api/v1/shared/error',
                 locals: { message: 'Failed to grant access', errors: perk_access.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        perk_access = PerkAccess.find_by(id: params[:id])
        unless perk_access
          return render 'api/v1/shared/error',
                      locals: { message: 'Perk access not found', errors: ['Perk access does not exist'] },
                      status: :not_found
        end

        perk_access.destroy
        @perk_access = perk_access
        render :destroy
      end
    end
  end
end



