<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->

<a id="readme-top"></a>

<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

<h3 align="center">DevOps Portfolio: Digital Resume</h3>

  <p align="center">
    My Infrastructure-as-Code that deploys a static S3 website.
    <br />
    <a href="https://github.com/jonathan-d-nguyen/portfolio-devops_resume"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/jonathan-d-nguyen/portfolio-devops_resume/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#1-about-the-project">About The Project</a>
      <ul>
        <li><a href="#11-built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#2-getting-started">Getting Started</a>
      <ul>
        <li><a href="#21-prerequisites">Prerequisites</a></li>
        <li><a href="#22-installation">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#3-usage">Usage</a>
      <ul>
        <li><a href="#31-docker-containers">Docker Containers</a></li>
        <li><a href="#32-terraform-infrastructure">Terraform Infrastructure</a></li>
        <li><a href="#33-running-tests">Running Tests</a></li>
        <li><a href="#34-cicd-pipeline">CI/CD Pipeline</a></li>
        <li><a href="#35-accessing-the-website">Accessing the Website</a></li>
      </ul>
    </li>
    <li><a href="#4-roadmap">Roadmap</a></li>
    <li>
      <a href="#5-contributing">Contributing</a>
      <ul>
        <li><a href="#51-top-contributors">Top contributors</a></li>
      </ul>
    </li>
    <li><a href="#6-license">License</a></li>
    <li><a href="#7-contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## 1. About The Project

This repository demonstrates my skills in containerization, testing, infrastructure as code, and CI/CD. It includes Dockerfiles, Docker Compose, RSpec, Capybara, Selenium, Terraform, Jenkins, and a CI/CD pipeline.

The website is my virtual business card/resume: <a href="http://www.jdnguyen.tech">www.jdnguyen.tech</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 1.1. Built With

- [![Docker][Docker.io]][Docker-url]
- [![Terraform][Terraform.io]][Terraform-url]
- [![Selenium][Selenium.dev]][Selenium-url]
- [![Jenkins][Jenkins.io]][Jenkins-url]
- [![Markdown][Markdown Guide]][Markdown-url]
- [![HTML5][HTML5 Doctor]][HTML5-url]
- [![JavaScript][JavaScript.com]][JavaScript-url]
- [![CSS3][CSS-Tricks]][CSS3-url]
<!--
- [![Next][Next.js]][Next-url]
- [![React][React.js]][React-url]
- [![Vue][Vue.js]][Vue-url]
- [![Angular][Angular.io]][Angular-url]
- [![Svelte][Svelte.dev]][Svelte-url]
- [![Laravel][Laravel.com]][Laravel-url]
- [![Bootstrap][Bootstrap.com]][Bootstrap-url]
- [![JQuery][JQuery.com]][JQuery-url]
- [![AWS][Amazon Web Services.com]][AWS-url] -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 2. Getting Started

Following this will allow you to self-host a container that will This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### 2.1. Prerequisites

1. AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

2. Install Docker - https://docs.docker.com/engine/install/
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

### 2.2. Installation

1. Clone repository.
   ```sh
   git clone https://github.com/jonathan-d-nguyen/portfolio-devops_resume.git
   ```
2. In Terminal, navigate to repo folder. Initialize Terraform:

   ```sh
   docker-compose run --rm terraform init
   docker-compose run --rm terraform plan
   docker-compose run --rm terraform apply
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->

## 3. Usage

This project demonstrates various DevOps practices and tools. Here's how you can use and explore different components:

### 3.1. Docker Containers

1. Build and run the Docker containers:
   ```sh
   docker-compose up --build
   ```

### 3.2. Terraform Infrastructure

1. Initialize Terraform:

```sh
docker-compose run --rm terraform init
```

2. Plan your infrastructure changes:

```sh
docker-compose run --rm terraform plan
```

3. Apply the infrastructure:

```sh
docker-compose run --rm terraform apply
```

### 3.3. Running Tests

Execute the test suite using:

```sh
docker-compose run --rm test
```

### 3.4. CI/CD Pipeline

The Jenkins pipeline is configured in the Jenkinsfile. To use it:

Ensure Jenkins is set up and running

Create a new pipeline job in Jenkins

Point the job to your repository

Jenkins will automatically detect the Jenkinsfile and run the defined stages

Accessing the Website
The static website is hosted on AWS S3 and can be accessed at: www.jdnguyen.tech

<!-- _For more examples, please refer to the [Documentation](https://www.jdnguyen.net)_ -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## 4. Roadmap

- [ ] Jenkins Deploy
  - Implement automated deployment using Jenkins CI/CD pipeline
- [ ] CloudFront Integration
  - [ ] Set up CloudFront distribution for content delivery
  - [ ] Configure Origin Access Control for enhanced security
  - [ ] Implement public access blocking for S3 origin
  - [ ] Integrate AWS Certificate Manager for HTTPS
  - [ ] Configure Route 53 for domain management
- [ ] Terraform State Management
  - Implement state persistence in S3 for better collaboration and versioning

See the [open issues](https://github.com/jonathan-d-nguyen/portfolio-devops_resume/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 5. Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 5.1. Top contributors:

<a href="https://github.com/jonathan-d-nguyen/portfolio-devops_resume/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=jonathan-d-nguyen/portfolio-devops_resume" alt="contrib.rocks image" />
</a>

<!-- LICENSE -->

## 6. License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## 7. Contact

Jonathan Nguyen - jonathan@jdnguyen.tech

Project Link: [https://github.com/jonathan-d-nguyen/portfolio-devops_resume](https://github.com/jonathan-d-nguyen/repo_name)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

- [Awesome README Template](https://github.com/othneildrew/Best-README-Template/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/jonathan-d-nguyen/portfolio-devops_resume.svg?style=for-the-badge
[contributors-url]: https://github.com/jonathan-d-nguyen/portfolio-devops_resume/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/jonathan-d-nguyen/portfolio-devops_resume.svg?style=for-the-badge
[forks-url]: https://github.com/jonathan-d-nguyen/portfolio-devops_resume/network/members
[stars-shield]: https://img.shields.io/github/stars/jonathan-d-nguyen/portfolio-devops_resume.svg?style=for-the-badge
[stars-url]: https://github.com/jonathan-d-nguyen/portfolio-devops_resume/stargazers
[issues-shield]: https://img.shields.io/github/issues/jonathan-d-nguyen/portfolio-devops_resume.svg?style=for-the-badge
[issues-url]: https://github.com/jonathan-d-nguyen/portfolio-devops_resume/issues
[license-shield]: https://img.shields.io/github/license/jonathan-d-nguyen/portfolio-devops_resume.svg?style=for-the-badge
[license-url]: https://github.com/jonathan-d-nguyen/portfolio-devops_resume/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/JonathanDanhNguyen
[product-screenshot]: images/screenshot.png
[Terraform.io]: https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white
[Terraform-url]: https://www.terraform.io/
[Docker.io]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Docker-url]: https://www.docker.com/
[Selenium.dev]: https://img.shields.io/badge/-selenium-%43B02A?style=for-the-badge&logo=selenium&logoColor=white
[Selenium-url]: https://www.selenium.dev/
[Jenkins.io]: https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white
[Jenkins-url]: https://jenkins.io/
[Amazon Web Services.com]: https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white
[AWS-url]: https://aws.amazon.com/
[HTML5 Doctor]: https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white
[HTML5-url]: https://html5doctor.com/
[JavaScript.com]: https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E
[JavaScript-url]: https://javascript.com/
[Markdown Guide]: https://img.shields.io/badge/markdown-%23000000.svg?style=for-the-badge&logo=markdown&logoColor=white
[Markdown-url]: https://www.markdownguide.org/
[CSS-Tricks]: https://img.shields.io/badge/css3-%231572B6.svg?style=for-the-badge&logo=css3&logoColor=white
[CSS3-url]: https://css-tricks.com/

<!--
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com
 -->
