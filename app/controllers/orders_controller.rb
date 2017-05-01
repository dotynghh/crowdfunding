class OrdersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource :plan

  def new
    @plan = Plan.includes(:project).find(params[:plan_id])
    custom_price = params[:custom_price]
    unless custom_price.nil?
      if custom_price.blank?
        flash[:alert] = "请输入 0-999999 之间的金额"
        redirect_back(fallback_location: root_path)
      else
        custom_price = Integer(custom_price) rescue nil
        if custom_price.nil? || custom_price < 0 || custom_price > 999999
          flash[:alert] = "请输入 0-999999 之间的金额"
          redirect_back(fallback_location: root_path)
        end
        @plan.price = custom_price
      end
    end
    @order = @plan.orders.build(price: @plan.price, quantity: @plan.quantity)
    authorize! :create, @plan
    set_page_title_and_description("新建订单-#{view_context.truncate(@plan.description, :length => 10)}", view_context.truncate(@plan.description, :length => 100))
  end

  def create
    payment_method = case params[:commit]
    when "微信支付"
      "WeChat"
    when "支付宝支付"
      "Alipay"
    end
    assemble_order
    unless deal_need_add?
      flash[:alert] = "请填写接收回报的地址"
      render "new"
      return
    end
    if @order.save
      if FundingService.new(@order, current_user, payment_method).add_progress!
        flash[:notice] = "您已成功付款，感谢您的支持！"
        res = OrderMailer.notify_order_placed(@order).deliver!
      else
        flash[:alert] = "付款失败，请重新尝试。"
      end
      redirect_to account_order_path(@order.token)
    else
      render "new"
    end
  end

  protected

  def deal_need_add?
    if @plan.need_add
      if @order.address.blank?
        false
      else
        true
      end
    else
      true
    end
  end

  def assemble_order
    @plan = Plan.includes(:project).find(params[:plan_id])
    @project = @plan.project
    @order = @plan.orders.build(order_params)
    @order.creator_name = @project.user.user_name
    @order.backer_name = current_user.user_name.blank? ? current_user.email : current_user.user_name
    @order.user = current_user
    @order.project = @project
    @order.address = Address.getAddress(params[:address_id]) if params[:address_id]
    @order.plan_description = @plan.description
    @order.project_name = @project.name
  end

  private

  def order_params
    params.require(:order).permit(:price, :quantity, :plan_id, :address)
  end
end
