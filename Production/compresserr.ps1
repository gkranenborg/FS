Send-MailMessage -To 'gerben.kranenborg@us.fujitsu.com, neal.wang@us.fujitsu.com, mahesh.giri@in.fujitsu.com, faisal.ansari@in.fujitsu.com' -Body 'The 7-zip file compression failed to compress the Full Backup !!' -Subject 'FS Production Server File Compression Failure' -from 'mail@bop.feinsuch.com' -smtpServer '127.0.0.1'