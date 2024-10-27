## JD Nguyen - Portfolio: Digital Resume

This repository demonstrates my skills in containerization, testing, infrastructure as code, and CI/CD. It includes Dockerfiles, Docker Compose, RSpec, Capybara, Selenium, Terraform, Jenkins, and a CI/CD pipeline. Deployable to S3/CloudFront.

The website is my virtual business card/resume www.jdnguyen.tech

**What's Included:**

- Dockerfiles for Terraform and RSpec and Docker-compose.yml to create a container and provision resources for the website.
- HTML, CSS, and JavaScript files for the website layout and interactivity.
- Images and other assets used throughout the website.
- A downloadable PDF of my full resume (Resume_Nguyen_Jonathan.pdf).

**Technologies Used:**

- AWS
- Docker
- Terraform
- RSpec
- Capybara
- Selenium
- Jenkins
- HTML5
- CSS3
- JavaScript

**Project Setup:**

(NOTE: This section is in progress)

1. Clone this repository.
2. Install and set up AWS CLI
   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
   https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html
3. Edit the docker-compose.yml by updating the AWS and Terraform Volume mounts to your own AWS credentials

```
aws:
    volumes:
      - $PWD:/app
      - /Users/jonathannguyen/.aws/credentials:/root/.aws/credentials
      - /Users/jonathannguyen/.aws/:/root/.aws/

[...]

  terraform:
    # entrypoint: /bin/sh
    build:
      dockerfile: terraform.Dockerfile
      context: .
      # making this available in docker compose as a service
    environment:
      AWS_REGION: "us-east-1"
    volumes:
      - $PWD:/app
      - /Users/jonathannguyen/.aws/credentials:/app/.aws/credentials
      - /Users/jonathannguyen/.aws/config:/app/.aws/config
```

1. [Install Docker](https://docs.docker.com/engine/install/) and enable Docker Engine.
2. In Terminal, navigate to root folder of repo. Initialize Terraform:
   `docker-compose run --rm terraform init`
   `docker-compose run --rm terraform plan`
   `docker-compose run --rm terraform apply`

**Customization:**

- Feel free to modify the HTML, CSS, and JavaScript files to personalize the website content and appearance to your liking.

**Downloading the Resume:**

- A downloadable copy of my full resume is available as "Resume_Nguyen_Jonathan.pdf".

**Contributing:**

This repository is currently not intended for external contributions. However, if you have any suggestions or bug reports, feel free to create an issue.

**Deployment:**

The live website hosted at www.jdnguyen.tech is built and deployed from this codebase.

**Contact:**

Feel free to reach out to me via the contact information provided on the website or through other professional channels.

**Disclaimer:**

The website content is intended for informational purposes only and may not be entirely exhaustive. Please refer to the downloadable resume ("resume.pdf") for a complete and up-to-date representation of my experience and qualifications.
