# scn-redmine
Redmine container for Seattle Community Network

## Usage

Copy the `sample.env` file to `.env`, and update the passwords
    
    cp sample.env .env
    vi .env
    REDMINE_SMTP_PASSWD=you_passwd
    REDMINE_IMAP_PASSWD=your_passwd

Deploy into a standard Docker engine with:
    
    sudo docker compose up -d
