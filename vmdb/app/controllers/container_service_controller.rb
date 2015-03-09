class ContainerServiceController < ApplicationController
  include ContainersCommonMixin

  before_filter :check_privileges
  before_filter :get_session_data
  after_filter :cleanup_action
  after_filter :set_session_data

  def index
    redirect_to :action => 'show_list'
  end

  def show_list
    process_show_list
  end

  def show
    @display = params[:display] || "main" unless control_selected?

    @lastaction = "show"
    @showtype = "main"
    @container_service = @record = identify_record(params[:id])
    return if record_no_longer_exists?(@container_service)

    @gtl_url = "/container_service/show/" << @container_service.id.to_s << "?"
    drop_breadcrumb({:name => "Services",
                     :url  => "/container_service/show_list?page=#{@current_page}&refresh=y"},
                    true)
    case @display
    when "download_pdf", "main", "summary_only"
      drop_breadcrumb( {:name => @container_service.name + " (Summary)",
                        :url  => "/container_service/show/#{@container_service.id}"} )
      set_summary_pdf_data if %w(download_pdf summary_only).include?(@display)
    end

    # Came in from outside show_list partial
    if params[:ppsetting]  || params[:searchtag] || params[:entry] || params[:sort_choice]
      replace_gtl_main_div
    end
  end

  private ############################
end
