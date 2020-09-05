module GuiderCms
  module ApplicationHelper
    def method_missing method, *args, &block
   if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
     if main_app.respond_to?(method)
       main_app.send(method, *args)
     else
       super
     end
   else
     super
   end
 end

 def respond_to?(method)
   if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
     if main_app.respond_to?(method)
       true
     else
       super
     end
   else
     super
   end
 end

 def subcat_prefix(depth)
  ("&nbsp;" * 4 * depth).html_safe
 end

 def category_options_array_for_article(current_id = nil,categories=[], parent_id=nil, depth=0)
  if categories == []
    root = Category.find(parent_id)
    categories << [subcat_prefix(depth) + root.classification, root.id]
    category_options_array(current_id,categories, root.id, depth+1)
  end
  categories
end

def article_options(id)
  req_array = []
  Category.find(id)
end



 def category_options_array(current_id = nil,categories=[], parent_id=nil, depth=0)
  # Category.where('parent_id = ? AND id != ?', parent_id, current_id ).order(:id).each do |category|
  Category.where(parent_id: parent_id).order(:id).each do |category|
      categories << [subcat_prefix(depth) + category.classification, category.id]
      category_options_array(current_id,categories, category.id, depth+1)
  end

  categories
end

def title(text)
    content_for :title, text
end

def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
end

def yield_meta_tag(tag, default_text='')
  content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
end

  end
end
