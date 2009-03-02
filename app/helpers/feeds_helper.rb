module FeedsHelper
  def channel_and_region_options(selected_key = nil)
    grouped_options = Region.enabled.all.map{|r| [r.name, r.channels.enabled.all.map{|c| [c.title, c.id] }]}
    body = ''
    grouped_options = grouped_options.sort if grouped_options.is_a?(Hash)
    grouped_options.each do |group|
      body << content_tag(:optgroup, options_for_select(group[1], selected_key), :label => group[0])
    end
    body
  end
end
