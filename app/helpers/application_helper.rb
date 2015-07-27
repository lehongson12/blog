module ApplicationHelper
	def full_title page_title = ''                     # Method def, optional arg
    base_title = "Inspiration Tour Website by SonLe"  # Variable assignment
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
