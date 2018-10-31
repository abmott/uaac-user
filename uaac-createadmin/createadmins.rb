
#color text
def colorize(text, color_code)
  "#{color_code}#{text}\x1B[0m"
end

def red(text); colorize(text, "\x1B[31m"); end
def green(text); colorize(text, "\x1B[32m"); end
def yellow(text); colorize(text, "\x1B[33m"); end
def blue(text); colorize(text, "\x1B[34m"); end
def white(text); colorize(text, "\x1B[37m"); end

#check if variable is a number
class String
  def numeric?
    Float(self) != nil rescue false
  end
end


#random code generator
def generate_code(length = 10, complexity = 4)
    subsets = [("a".."z"), ("A".."Z"), (0..9), ("#".."*"), ("+".."?")]
    chars = subsets[0..complexity].map { |subset| subset.to_a }.flatten
    chars.sample(length).join
end

wrkdir = Dir.pwd

# vaiable order - uaac admin password, adminuser

if ARGV[0] == "help"
  then
    puts green("Command line Options")
    puts ""
    puts "    uaac-admin-password"
    puts "    AdminName"
    print yellow("        admin username, if more than on enter:")
    print white (" \"AdminName1, AdminName2, AdminName3,...\" ")
    puts ""
    puts "Example: ./createadmins.rb uaacPassword AdminName"
    puts "Example: ./createadmins.rb uaacPassword \"AdminName1, AdminName2, AdminName3\""
    puts ""
  exit
end




if not ARGV[0]
then
# check uaac target
target = `uaac target`.split(' ')
  #print target[0]
  puts green("Is this OK Target: #{target[1]}: (y/n)")
  choice = gets.chop
else
  choice = "yes"
end

case choice
    when
      "y", "Y", "yes", "Yes"
        puts "OK!"
        if not ARGV[0]
          then
            print green("Enter uaac admin password: ")
            uaacadminpass = gets.chomp
            output = `uaac token client get admin -s #{uaacadminpass}`
          else
            output = `uaac token client get admin -s #{ARGV[0]}`
            puts output
          end




    when
      "n", "N", "no", "No"
        print "Please Set Correct Target: "
        uaactarget = gets.chop
        output = `uaac target #{uaactarget}`
        puts output
        print "Enter uaac admin password: "
        uaacadminpass = gets.chomp
        output = `uaac token client get admin -s #{uaacadminpass}`
        puts output
end


if not ARGV[1]
then
puts ""
print green("Enter Admin accounts seperated by a comma: ")
adminusernames = gets.chomp
adminusers = adminusernames.split(/\s*,\s*/)
else
  adminusers = ARGV[1].split(/\s*,\s*/) # ****** Put admin user account names here. *********
end

adminusers.each do |admins|
  #puts "admin user #{admins}"
#end
  password = generate_code(15, 3)
  #puts password
  output = `uaac user add #{admins} -p "#{password}" --emails #{admins}@csaa.com`
  #print green("#{output} for")
  #puts admins
  newuser = File.new("#{wrkdir}/cf_created_admin/createdadmin.txt", "a")
  newuser.puts "#{admins} has been created and the password has been set to: #{password}"
  newuser.close

  print "#{admins}"
  print yellow(" has been created and the password has been set to: ")
  print "#{password}"
  puts blue(" -- details written to #{wrkdir}/cf_created_admin/createdadmin.txt")
end

adminusers.each do |admins|
    `uaac member add cloud_controller.admin #{admins}`
    `uaac member add uaa.admin #{admins}`
    `uaac member add scim.read #{admins}`
    `uaac member add scim.write #{admins}`
    print green("Cloud_controller.admin, uaa.admin, scim.read, and scm.write Admin roles added to ")
    puts admins
end
