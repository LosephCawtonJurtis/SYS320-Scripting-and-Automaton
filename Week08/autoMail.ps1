# Storyline: send an emial.

# Body of email
# variables can have an underscore or any alphanumeric value.
$msg = "Hello there."

# echoing to the screen.
write-host -BackgroundColor Red -ForegroundColor white $msg
# Email From Address
$email = "joseph.lawtoncurtis@mymail.champlain.edu"

# to address
$toEmail = "deployer@csi-web"

# sending the email
Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" -body $msg -SmtpServer 192.168.6.71
