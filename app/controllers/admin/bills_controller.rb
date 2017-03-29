class Admin::BillsController < AdminController
  before_action :find_fund_rate, only: %i(index payout_index payments_index show_bill_payments show_bill_payouts)

  def index
    @bill_payments = BillPayment.bill_payment_by_project_id(%w(success paid))
    # @bill_payout = BillPayment.where(bill_status: "success")
    set_page_title_and_description("收入流水", nil)
  end

  def payout_index
    @bill_payouts = BillPayout.bill_payout_by_project_id(%w(success paid))
    set_page_title_and_description("支出流水", nil)
  end

  def payments_index
    @payment_amount = BillPayment.where(bill_status: %w(success paid)).sum(:amount)
    @payout_amount = BillPayout.where(bill_status: "paid").sum(:amount)
    set_page_title_and_description("收支情况", nil)
  end

  def custom_fund_rate
    ENV["fund_rate"] = params[:fund_rate]
    flash[:notice] = "服务费比例修改成功"
    redirect_back(fallback_location: root_path)
  end

  def find_fund_rate
    @fund_rate = ENV["fund_rate"]
  end

  def show_bill_payments
    query_type = params[:query_type]
    @bill_payments =
      case query_type
      when "success_bill"
        BillPayment.bill_payment_by_project_id(%w(success paid))
      when "faild_bill"
        BillPayment.bill_payment_by_project_id(["faild", ""])
      when "wait_bill"
        BillPayment.bill_payment_by_project_id(["wait", ""])
      else
        BillPayment.bill_payment_by_project_id(%w(success paid))
      end
    render json: @bill_payments
  end

  def show_bill_payouts
    query_type = params[:query_type]
    @bill_payouts =
      case query_type
      when "success_bill"
        BillPayout.bill_payout_by_project_id(%w(success paid))
      when "faild_bill"
        BillPayout.bill_payout_by_project_id(["faild", ""])
      when "wait_bill"
        BillPayout.bill_payout_by_project_id(["wait", ""])
      else
        BillPayout.bill_payout_by_project_id(%w(success paid))
      end
    render json: @bill_payouts
  end

  def show_bill_payments_by_project
    @payments = BillPayment.success_payment_by_project(params[:id])
    set_page_title_and_description("项目详细收入流水", nil)
  end

  def payout
    @project = Project.find(params[:id])
    amount = BillPayment.where(bill_status: "success", project_id: params[:id]).sum(:amount)
    final_amount = ((100 - ENV["fund_rate"].to_f) / 100) * amount
    if PayoutService.new(@project, final_amount).perform!
      BillPayment.where(project_id: params[:id]).update_all(bill_status: "paid")
      flash[:notice] = "资金发放成功！"
    else
      flash[:danger] = "资金发放失败！"
    end
    redirect_back(fallback_location: root_path)
  end
end
