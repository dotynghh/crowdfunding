class ProjectsController < ApplicationController
	def new
		@project = Project.new
	end

	def create
		@project = Project.new(project_attr)
		if @project.save
			flash[:notice] = "项目发起成功，待审核"
			redirect_to root_path
		else
			flash[:notice] = "项目发起失败，请检查"
			render action: :new
		end
	end

	def show
		@project = Project.find params[:id]
	end

	def edit
		@project = Project.find params[:id]
	end

	def update
		@project = Project.find params[:id]
		if @project.update_attributes(project_attr)
			flash[:notice] = "更新成功"
			redirect_to :back
		else
			flash[:notice] = "更新失败"
			redirect_to :back
		end
	end

	def delete
		@project = Project.find params[:id]
		if @project.destroy
			flash[:notice] = "删除成功"
			redirect_to :back
		else
			flash[:notice] = "删除失败"
			redirect_to :back
		end
	end

	private

	def project_attr
		params.require(:project).permit!
	end
end
