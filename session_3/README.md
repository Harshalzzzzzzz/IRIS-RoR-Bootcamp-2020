# Session 3 - Controller, Devise

- Clone the repo and navigate to the blogs application `$ cd session_3/Blog`
- `$ rake db:create`
- `$ rake db:migrate`
- Add the required gem to Gemfile: `gem 'devise'`
- Run on terminal `$ bundle install`

## Devise :

- Run `$ rails generate devise:install`
- `$ rails generate devise user` to create a migration for User with email, password and other attributes.
- Now run `$ rake db:migrate`
-  Now generate the views for devise using `$ rails generate devise:views users`
- `$ rails generate migration AddUserToBlogs user:references`
Every User has a unique primary key (user_id).
The  primary key (i.e. user_id of Users table) will be used in a different table for reference (in Blogs table here) is called foreign key.
Start the server `$ rails server` and navigate to localhost:3000/blogs. You will be redirected to a login page.

## Tasks :

- Create CRUD actions for the BlogsController
- To store user_id for create action : @blogs.user = current_user
- `@blog = Blog.where(user_id: current_user.id)` This line enables us to fetch only those posts which were made by this User
- Add a migration for Blogs `visibility - boolean`, and add a controller method for updating the field to display only those where `visibility: true`.
- Add routes for the actions/methods.
- Add before_action for update and delete action while allowing users to view show and index pages without authentication. 
- Add [associations](https://guides.rubyonrails.org/association_basics.html) for the User and Blog table in models.

You can also update or create records  by using rails console to run ActiveRecord commands. 
For eg, Run `$ rails console`, then type `Blog.create(title: "Hello", content: "Blog App", visibility: true)`

 ## References :
 
 - https://guides.rubyonrails.org/v2.3.11/association_basics.html
 - https://guides.rubyonrails.org/v5.2/routing.html
 - https://www.sitepoint.com/10-ruby-on-rails-best-practices-3/
 - https://guides.rubyonrails.org/action_controller_overview.html
 - https://api.rubyonrails.org/v6.1.0/classes/ActionController/StrongParameters.html
