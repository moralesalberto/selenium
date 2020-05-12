require 'selenium-webdriver'

require 'byebug'

def username
  'xxx'
end

def password
  'xxx'
end

def driver
  @driver ||= Selenium::WebDriver.for :chrome
end

def login
  driver.navigate.to "https://www.instagram.com/accounts/login/"
  sleep(1)
  driver.find_element(name: 'username').send_keys(username)
  driver.find_element(name: 'password').send_keys(password)
  button = driver.find_element(xpath: "//button[@type='submit']")
  puts button.inspect
  button.send_keys(:enter)
end

# find followers
def find_followers
  # traverse to the user's profile
  driver.navigate.to('https://www.instagram.com/' + username)
  # find the followers link
  followers_link = driver.find_elements(css: 'a').select {|el| el.text =~ /followers/ }.first
  # click on the followers link
  # this should open up the modal with the followers
  followers_link.click
  # wait for a bit
  sleep(2)

  # return the links for the followers
  driver.find_elements(css: 'li a').map { |el| el.attribute('href') }
end

def message(follower)
  # go to the user's profile
  driver.navigate.to(follower)
  # find the message button
  button = driver.find_element(xpath: "//button[contains(text(), 'Message')]")
  # send them a message
  button.click
  sleep(2)
end

# run the program
login
sleep(3)
followers = find_followers
# for each follower go to their page and message them
followers.each do |follower|
  if follower =~ /criteria/
    message(follower)
    break
  end
end
sleep(30)



