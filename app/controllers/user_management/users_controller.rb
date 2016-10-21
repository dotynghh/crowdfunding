class UserManagement::UsersController < UserManagement::BasesController

  def show

  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update(attr_update)
      flash[:notice] = '修改成功'
      redirect_to user_management_user_path(@user)
    else
      flash[:notice] = '修改失败'
      render action: :edit
    end
  end

  private
  def attr_update
    params.require(:user).permit(:password, :avatar)
  end

end