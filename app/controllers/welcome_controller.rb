class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @projects  = Project.find(1,2,3)
  end

  def how_it_works
    @projects  = Project.find(1,2,3)
    set_page_title_and_description("用户指南", nil)
  end

  def help_term
    set_page_title_and_description("服务协议", nil)
    render layout: "about_us"
  end

  def about_us
    set_page_title_and_description("关于我们", nil)
    render layout: "about_us"
  end
  def contact_us
    set_page_title_and_description("联系我们", nil)
    render layout: "about_us"
  end
end
