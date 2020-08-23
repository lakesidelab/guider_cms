# GuiderCms
GuiderCms is a plugin which provides CMS functionality for multiple root origins  
Is Rack Based  
Based on MVC using rails engines  
Allows you to have a CMS for multiple purposes  
Supports for categories and subcategories for all root origin


## Prerequisite
***Please Ensure you have active storage and active text set up in your application***


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'guider_cms'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install guider_cms
```
to generate the initializer file run
```bash
$ rails g guider_cms:install
```

In config/initializers/guider.rb set the name of your primary user model
```ruby
  GuiderCms.author_class = "YOUR_USER_MODEL_CLASS"
```

then to generate all the migration files
```bash
$ rails guider_cms:install:migrations
```

then finally create the tables
```bash
$ rails db:migrate
```

in app/models/your_user_model.rb, add
This is done to create the association between the user and articles table
```ruby
has_many :guider_cms_articles , class_name: 'GuiderCms::Article', foreign_key: :author_id  
```

in app/views/layout/application.html.erb include
```html
  <%= stylesheet_link_tag  "guider_cms/application", media: "all" %>
```
this includes all the css for the engine

***You need atleast one root category to start working in guiderCMS***  
Root categories can be things used to represent top of the any cms system  
eg: Blogs, Articles, etc.  
To start, navigate to guider_home_page
```ruby
  guider_home_path
```
This part will ask you to create a new root category if none exists, Then you will have to create categories that come under this root visiting home path again will take you right there

## Routing
Consider you have a root category called "Blogs"  
And in Blogs you have categories such as Computer science and Artificial Intelligence  
Here Computer Science and Artificial Intelligence are main categories in Root Blogs  
Main categories can have subcategories, such as Artificial Intelligence can have subcategories such as machine learning  

So your root blogs is arranged in this way  
- Blogs
  - Computer Science
  - Artificial Intelligence
    - Machine Learning

To visit the home/index page:
```ruby
guider_home_path
```
To view index for specific root category:
```ruby
content_new_back_path(root: "Blogs")
```
To view index for specific root and selected category:
```ruby
contents_path(root: "Blogs", selected_category: "Artificial Intelligence")
```
the same for subcategory among the main categories
```ruby
contents_path(root: "Blogs", selected_category: "Machine Learning")
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
