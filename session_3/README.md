# Session 3 - Controller, Devise

We will continue with Rails Controller and Devise, a gem used for authentication in our application, and also learn how CRUD actions can be performed with relational databases using the associations between different tables.

- Change directory and navigate to the project. ``$ cd session_3/Blog``
- To create the database `$ rake db:create`
- Run `$ rake db:migrate` to add migrations to the database. This will update your db/schema.rb file to match the structure of your database.

> Before we start with devise, let's understand how various models can have associations between other tables and how migrations can be used to change tables and database.

## Alter Databases Using Migrations

[Migrations](https://github.com/IRIS-NITK/IRIS-RoR-Bootcamp-2020/tree/main/session_2/student_registry) are a convenient way to alter your database schema over time in a consistent way. 

When you generate new migrations to add models or columns, Active Record tracks which migrations have already been run so all you have to do is update your source and run `rake db:migrate`. Active Record will work out which migrations should be run and update your `db/schema.rb` file accordingly. For example,

To add a new column, run : 
`$ rails generate migration AddAuthorToBlogs author:string`.

This will generate a migration in `db/migration/<YYYYMMDDHHMMSS>_add_author_to_blogs.rb` that looks like :
```
class AddAuthorToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :author, :string
  end
end
```
In the relational database, key is the most important element to maintain the relationship between two tables or to uniquely identify data from the table.
Primary key is used to identify data uniquely therefore two rows can’t have the same primary key and it cannot have a null value.

> The primary key is defined as a column where each value is unique and identifies a single row of the table. 

> A primary key-foreign key relationship defines a one-to-many relationship between two tables in a relational database.

> A foreign key is a column or a set of columns in one table that references the primary key columns in another table.

A Migration adds a table with a primary key column called `id` which will also be added implicitly, as it's the default primary key for all Active Record models. The timestamps macro adds two columns, `created_at` and `updated_at` as well. 

> By default, the generated migration for a model will include t.timestamps which creates the updated_at and created_at columns that are automatically populated by Active Record, when a new record is created in the table.

## Associations in Relational Database :

An association is a connection between two Active Record models. For example, consider a simple Rails application that includes a [model](https://github.com/IRIS-NITK/IRIS-RoR-Bootcamp-2020/tree/main/session_2) for blog articles and a model for books. Each author can have many blog articles, but an article can belong only to a particular user. 

A `belongs_to` association sets up a connection with another model, such that each instance of the declaring model "belongs to" one instance of the other model.

A `has_one` association indicates that one other model has a reference to this model. 

While a `has_many` association is similar to has_one, but indicates a one-to-many connection with another model.

In order to have a connection between two models, with Active Record associations, we can streamline these operations by declaratively telling Rails that there is a connection between the two models. For example, with associations the model declarations would look like this:

```
## app/models/user.rb
class User < ApplicationRecord
  has_many :blogs, dependent: :destroy 
end

## app/models/blog.rb
class Blog < ApplicationRecord
  belongs_to :user
end
```
Here `dependent: :destroy` controls what happens to the associated objects when their association is destroyed, in this case it destroys all records created by a particular user.

## Devise :

- Add the required gem to Gemfile: `gem 'devise'`
- Next run on terminal `$ bundle install`
- Run the following command to generate Devise configuration file `config/initializers/devise.rb` which contains a lot of different configuration options:
  `$ rails generate devise:install`
- To generate a User model required by devise for authentication, run `$ rails generate devise User` 
 This creates a `user.rb` model file and a migration that adds all the necessary fields.

- Now to generate the views for devise login, run `$ rails generate devise:views users`

- Now we will add a migration which will create a column user_id (foreign key) in our blogs table so that we know which user has created the corresponding Blog.
The  primary key (i.e. user_id of Users table) will be used in a different table for reference in Blog table here is called foreign key.
So here if we check any blog's user_id we will get to know which user created that blog by checking the corresponding user from users table.
Run `$ rails generate migration AddUserToBlogs user:references`.

- Now, run `$ rake db:migrate` to make changes to the existing schema.

- Open `models/user.rb`, your model will look like this, once you have added associations :

```
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable      
  has_many :blogs, dependent: :destroy
end
```
Start the server `$ rails server` and navigate to localhost:3000/blogs. You will be redirected to a login page.

## Controller :

After integrating our application with device, we can proceed with controller actions.

- Create CRUD actions for the BlogsController. (create, new, show, index, edit, update,destroy)
- Now, in order to ensure that a user is logged in for an action to be run, use `before_action` in controller :
```
class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
 .
 .
 .
end 
``` 
The `authenticate_user!` class method (controller), ensures a logged in user is available to all, or a specified set of controller actions.
- To ensure that records created by a user can be updated or deleted by a user only,   
```
class BlogsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_author, only: [:edit, :update, :destroy]

  def require_author
    redirect_to(root_path) unless @blog.user_id == current_user
  end
end
```
- To store user_id for create action :
```
def new
  @blog = Blog.new
end
  
def create
   @blog  = Blog.new(blog_params)
   @blogs.user = current_user
   if @blog .save
      redirect_to :action => 'blog'
   else
      render :action => 'new'
   end
end
```
The `current_user` is a helper that simply returns the model class relating to the signed in user. It returns nil if a user has not, as yet, signed in.
- To customize your index page so that only the blogs made by the current user are visible, 
```
def index
  @blogs = Blog.where(user_id: current_user.id)
end
```
- To add [routes](https://guides.rubyonrails.org/routing.html) for the controller actions :
```
## app/config/routes.rb 
Rails.application.routes.draw do
  devise_for :users
  resources :blogs  
  root 'blogs#index'
end
```

## Tasks (Optional):
- You can start with integrating devise by following the above steps.
- Add a migration for Blogs model `visibility (boolean)`, and create a controller method `update_visibility` for updating the field to display only those blogs where `visibility: true`. Note that only the author should be able to set the visibility.
- Set an appropriate `before_action` for `update_visibility` and modify your `routes.rb` file. 

 ## References :
 
 - https://guides.rubyonrails.org/v2.3.11/association_basics.html
 - https://www.sitepoint.com/10-ruby-on-rails-best-practices-3/
 - https://guides.rubyonrails.org/action_controller_overview.html
 - https://api.rubyonrails.org/v6.1.0/classes/ActionController/StrongParameters.html
