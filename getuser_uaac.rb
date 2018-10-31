#!/usr/bin/env ruby
#set uaac target
require 'io/console'
wrkdir = Dir.pwd

#color text
def colorize(text, color_code)
  "#{color_code}#{text}\x1B[0m"
end

def red(text); colorize(text, "\x1B[31m"); end
def green(text); colorize(text, "\x1B[32m"); end
def yellow(text); colorize(text, "\x1B[33m"); end
def blue(text); colorize(text, "\x1B[34m"); end
def white(text); colorize(text, "\x1B[37m"); end



if ARGV[0] == "help"
  then
    puts green("Command line Options")
    puts ""
    puts "    uaactarget"
    puts ""
  exit
end



if not ARGV[0]
then

#Designate UAAC Target
  puts ""
  print "UAAC Target: -> "
    uaactarget = gets.chop
  else uaactarget = ARGV[0]
end

case uaactarget
when "pdc"
  uaactarget = "https://uaa.sys.prod.pdc.digital.csaa-insurance.aaa.com"
when "sandbox"
  uaactarget = "https://uaa.sys.sandbox.gdc.digital.pncie.com"
when "gdc"
  uaactarget = "https://uaa.sys.prod.gdc.digital.csaa-insurance.aaa.com"
else
  puts "Unkown Target"
end


target = `uaac target #{uaactarget}`
puts target


if not ARGV[0]
then
#prompt user for Client Secret (password)
print "UAAC Client Secret: -> "
    uaacclientsecret = STDIN.noecho(&:gets).chomp
token = `uaac token client get admin -s #{uaacclientsecret}`
puts token
else
  puts "password already set"
  puts ""
  puts ""
end

#create users.txt will all data from command
 `uaac users -a username > users.txt`

#parse user.txt only putting usernames into array
userslist = []
File.new("users.txt").each do |line|
   if line[/username/]
     userslist << line.split(":")[-1].strip
  end
end
File.delete("users.txt")
puts green("USERS")
puts userslist.sort
