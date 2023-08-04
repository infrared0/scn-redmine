# scn-redmine
Redmine container for Seattle Community Network

## Usage

Copy the `sample.env` file to `.env`, and update the passwords
    
    cp sample.env .env
    vi .env
    REDMINE_SMTP_PASSWORD=your_password
    REDMINE_IMAP_PASSWORD=your_password

Deploy into a standard Docker engine with:
    
    sudo docker compose up -d
