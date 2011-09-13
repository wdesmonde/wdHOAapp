# by using the symbol ':user', we get Factory Girl to simulate the 
#    User model.

Factory.define :user do |user|
  user.name    "Some Won"
  user.email   "somewon@example.com"
  user.password "foolishbar"
  user.password_confirmation  "foolishbar"
end

Factory.sequence :email do |n|
  "mishaho-#{n}@doogma.net"
end
