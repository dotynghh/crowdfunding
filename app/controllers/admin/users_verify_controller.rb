class Admin::UsersVerifyController < AdminController
  def index
    @users = User.where(:verify_status.zero?)
  end

  def show
    @user = User.find(params[:id])
  end

  def pass_verify
    @user = User.find(params[:id])
    @user.approve!
    flash[:notice] = "已通过该用户的实名认证申请!"
    redirect_to :back
    # UserMailer.notify_order_placed(@user).deliver!
  end

  def reject_verify
    @user = User.find(params[:id])
    @user.reject!
    flash[:notice] = "已拒绝该用户的实名认证申请!"
    redirect_to :back
    # UserMailer.notify_order_placed(@user).deliver!
  end

  private

  def user_verify
    params.require(:identiy_verification).permit(:verify_status, :message)
  end
end
