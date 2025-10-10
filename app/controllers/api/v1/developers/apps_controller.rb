module Api
  module V1
    module Developers
      class AppsController < ApiController
        # GET /api/v1/developers/:developer_id/apps (RESTful nested route)
        def index
          developer = Developer.find_by(id: params[:developer_id])
          
          unless developer
            render 'api/v1/shared/error', 
                   locals: { message: 'Developer not found', errors: nil }, 
                   status: :not_found, 
                   formats: [:json]
            return
          end
          
          @apps = filter_apps_by_status(developer.apps).includes(:api_keys)
          render :index, formats: [:json]
        end

        # GET /api/v1/developers/apps/:id
        def show
          @app = App.includes(:api_keys, :category, :sector).find_by(id: params[:id])
          
          unless @app
            render 'api/v1/shared/error', 
                   locals: { message: 'App not found', errors: nil }, 
                   status: :not_found, 
                   formats: [:json]
            return
          end
          
          render :show, formats: [:json]
        end

        # POST /api/v1/developers/apps
        def create
          developer = Developer.find_by(id: params[:developer_id])
          
          unless developer
            render 'api/v1/shared/error', 
                   locals: { message: 'Developer not found', errors: nil }, 
                   status: :not_found, 
                   formats: [:json]
            return
          end
          
          @app = developer.apps.build(app_params)
          
          if @app.save
            render :create, formats: [:json], status: :created
          else
            render 'api/v1/shared/error', 
                   locals: { message: 'Failed to create app', errors: @app.errors.full_messages }, 
                   status: :unprocessable_entity, 
                   formats: [:json]
          end
        end

        # PATCH /api/v1/developers/apps/:id
        def update
          @app = App.find_by(id: params[:id])
          
          unless @app
            render 'api/v1/shared/error', 
                   locals: { message: 'App not found', errors: nil }, 
                   status: :not_found, 
                   formats: [:json]
            return
          end
          
          if @app.update(app_params)
            render :update, formats: [:json]
          else
            render 'api/v1/shared/error', 
                   locals: { message: 'Failed to update app', errors: @app.errors.full_messages }, 
                   status: :unprocessable_entity, 
                   formats: [:json]
          end
        end

        # DELETE /api/v1/developers/apps/:id
        def destroy
          @app = App.find_by(id: params[:id])
          
          unless @app
            render 'api/v1/shared/error', 
                   locals: { message: 'App not found', errors: nil }, 
                   status: :not_found, 
                   formats: [:json]
            return
          end
          
          # Soft delete: set status to disabled
          if @app.update(status: :disabled)
            render :destroy, formats: [:json]
          else
            render 'api/v1/shared/error', 
                   locals: { message: 'Failed to disable app', errors: @app.errors.full_messages }, 
                   status: :unprocessable_entity, 
                   formats: [:json]
          end
        end

        private

        def app_params
          params.permit(
            :name,
            :description,
            :app_url,
            :status,
            :category_id,
            :sector_id
          )
        end

        def filter_apps_by_status(apps_relation)
          return apps_relation unless params[:status].present?
          
          status = params[:status].to_s.strip.downcase
          
          # Validate status value against App model's enum values
          valid_statuses = App.statuses.keys
          unless valid_statuses.include?(status)
            return apps_relation
          end
          
          apps_relation.where(status: status)
        end
      end
    end
  end
end

