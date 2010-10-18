module Dashboard::DashboardHelper
  def table_tr_attrs(index)
    { :class => index == 0 ? "first" : (index.even? ? nil : "even") }
  end
end
