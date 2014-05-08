# Demo
class Person extends Model
  @property 'fullName',
    get: -> "#{@firstName} #{@lastName}"
    set: (name) -> [@firstName, @lastName] = name.split ' '
  @property 'username'
  @property 'sick', default: false

class Post extends Model
  @field 'title', default: 'New post!'
  @field 'body'
  # the default is supplied as a closure which is evaluated at object creation time
  @property 'created_at', default: -> new Date()

# Create a new user
user = new User
  username: 'tom'
  twitter: 'almostobsolete'

# Bind to the change event for the title property
# user.bind 'change:username', (value) =>
#   alert "Username updated to #{value}"
# # Print out details of posts when they are created by the user
# user.bind 'add:posts', (post) =>
#   alert "Post titled #{post.get('title')} was written at #{post.get('created_at')}"
# # Print out details of posts when they are created by the user
# user.bind 'remove:posts', (post) =>
#   alert "Post titled #{post.get('title')} was removed"

# # Change the user's username (which will trigger the event bound above)
# user.set('username', 'thomas')