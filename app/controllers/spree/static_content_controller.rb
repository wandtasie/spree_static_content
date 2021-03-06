class Spree::StaticContentController < Spree::BaseController
  caches_action :show, :cache_path => Proc.new { |controller|
    "spree_static_content/" + controller.params[:path]
  }
  
  layout :determine_layout
  
  def show
    path = case params[:path]
    when Array
      '/' + params[:path].join("/")
    when String
      '/' + params[:path]
    when nil
      request.path
    end
    path = path.gsub('//','/')
    path = StaticPage::remove_spree_mount_point(path) unless Rails.application.routes.url_helpers.spree_path == "/"
    
    unless @page = Spree::Page.visible.find_by_slug(path)
      render_404
    end
  end

  private
  
  def determine_layout
    return @page.layout if @page and @page.layout.present?
    'spree/layouts/spree_application'
  end

  def accurate_title
    @page ? (@page.meta_title.present? ? @page.meta_title : @page.title) : nil
  end
end

