class FundingService
  def initialize(order, user, payment_method)
    @order = order
    @project = @order.project
    @plan = @order.plan
    @user = user
    @payment_method = payment_method
  end

  # TODO: 需要加锁、加事务
  def add!
    @project.fund_progress += @order.total_price
    # @user.orders.where("orders_count = ? AND locked = ?", params[:orders], false)
    if @user.orders.where(project_id: @order.project).paid.empty?
      @project.backer_quantity += 1
    end
    @project.save

    if @user.orders.where(plan_id: @order.plan).paid.empty?
      @plan.backer_quantity += 1
    else
      @user.orders.where(plan_id: @order.plan)
    end
    @plan.plan_progress += 1
    @plan.save
    @order.pay!(@payment_method)
    BillPayment.create(
      order_id: @order.id, channel_id: 0,
      amount: @order.total_price, user_id: @user.id, backer_name: @order.backer_name, project_id: @project.id, project_name: @project.name,
      plan_id: @plan.id, bill_status: "success", payment_method: @order.payment_method,
      plan_description: @plan.description
    )

    @account = @user.account
    @account.amount += @order.total_price
    @account.save
  end

  def add_progress!
    add!
    # send_notification!
  end

  def send_notification!
    Notification.create(recipient: @project.user, actor: @user, action: "fund", notifiable: @order)
  end
end
