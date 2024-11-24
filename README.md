<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->

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
    A Infrastructure-as-Code project that deploys a static S3 website with CloudFront distribution.
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
      <a href="#2-quick-start">Quick Start</a>
      <ul>
        <li><a href="#21-prerequisites">Prerequisites</a></li>
        <li><a href="#22-basic-setup">Basic Setup</a></li>
      </ul>
    </li>
    <li>
      <a href="#3-deployment--operations">Deployment & Operations</a>
      <ul>
        <li><a href="#31-full-installation-steps">Full Installation Steps</a></li>
        <li><a href="#32-testing--verification">Testing & Verification</a></li>
        <li><a href="#33-troubleshooting">Troubleshooting</a></li>
        <li><a href="#34-cicd-pipeline">CI/CD Pipeline</a></li>
        <li><a href="#35-cleanup">Cleanup</a></li>
      </ul>
    </li>
    <li><a href="#4-roadmap">Roadmap</a></li>
    <li>
      <a href="#5-contributing">Contributing</a>
      <ul>
        <li><a href="#51-top-contributors">Top Contributors</a></li>
      </ul>
    </li>
    <li><a href="#6-license">License</a></li>
    <li><a href="#7-contact">Contact</a></li>
    <li><a href="#8-acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- Back to top link template for use throughout document -->

<a id="readme-top"></a>

<!-- ABOUT THE PROJECT -->

## 1. About The Project

This repository demonstrates DevOps practices including containerization, testing, infrastructure as code, and CI/CD. It deploys a static website to AWS using S3 and CloudFront, serving as my virtual business card/resume at [www.jdnguyen.tech](http://www.jdnguyen.tech).

Are you looking over projects for the Learn To Cloud internship? Please also check out my Python-based project at [https://github.com/jonathan-d-nguyen/payment-notification-aggregator](https://github.com/jonathan-d-nguyen/payment-notification-aggregator)

Thanks!

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

<!-- QUICK START -->

## 2. Quick Start

Get up and running quickly with these basic steps. For detailed instructions, see [Full Installation Steps](#31-full-installation-steps).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 2.1. Prerequisites

1. **AWS CLI**

   ```sh
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install

   # Configure AWS credentials
   aws configure
   ```

2. **Docker**

   ```sh
   # Install Docker (Ubuntu example)
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh

   # Start Docker service
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

3. **Required AWS Permissions**
   - S3 full access
   - CloudFront full access
   - Route 53 domains full access
   - ACM certificate manager full access

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 2.2. Basic Setup

1. **Clone and prepare**

   ```sh
   git clone https://github.com/jonathan-d-nguyen/portfolio-devops_resume.git
   cd portfolio-devops_resume
   ```

2. **Deploy infrastructure**

   ```sh
   docker-compose run --rm terraform init
   docker-compose run --rm terraform apply
   ```

3. **Deploy website**
   ```sh
   docker-compose run --rm --entrypoint aws aws s3 cp --recursive /app/website_files s3://your-domain.com
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- DEPLOYMENT & OPERATIONS -->

## 3. Deployment & Operations

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 3.1. Full Installation Steps

1. **Repository Setup**

   ```sh
   git clone https://github.com/jonathan-d-nguyen/portfolio-devops_resume.git
   cd portfolio-devops_resume
   ```

2. **Infrastructure Deployment**

   ```sh
   # Initialize Terraform
   docker-compose run --rm terraform init

   # Preview changes
   docker-compose run --rm terraform plan

   # Apply infrastructure
   docker-compose run --rm terraform apply
   ```

   Save the outputs:

   ```sh
   cloudfront_distribution_id = "XXXXXXXXXXXX"
   website_bucket_url = "your-domain.com.s3..."
   ```

3. **Website Deployment**

   ```sh
   docker-compose run --rm --entrypoint aws aws s3 cp --recursive /app/website_files s3://your-domain.com
   ```

4. **Domain Configuration**

   1. **Certificate Setup (ACM)**

      - Navigate to ACM in us-east-1 region
      - Request public certificate for your domain
      - Add domain names:
        ```
        your-domain.com
        *.your-domain.com
        ```
      - Choose DNS validation
      - Create validation records in Route 53

   2. **DNS Setup (Route 53)**

      - Create/select hosted zone
      - Update nameserver records at your registrar
      - Create records:
        ```
        A record: your-domain.com → CloudFront distribution
        CNAME record: www.your-domain.com → your-domain.com
        ```

   3. **CloudFront Setup**
      - Configure alternate domain names
      - Select ACM certificate
      - Set default root object: index.html
      - Configure price class
      - Set up custom error responses if needed

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 3.2. Testing & Verification

1. **Infrastructure Tests**

   ```sh
   # Run test suite
   docker-compose run --rm test

   # Verify S3 bucket
   aws s3 ls s3://your-domain.com

   # Check CloudFront status
   aws cloudfront get-distribution --id YOUR_DISTRIBUTION_ID
   ```

2. **Website Verification**
   - Visit https://your-domain.com
   - Test www and non-www domains
   - Verify all pages load
   - Check SSL certificate validity
   - Confirm CDN caching

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 3.3. Troubleshooting

1. **Certificate Issues**

   ```sh
   # Check certificate status
   aws acm describe-certificate --certificate-arn arn:aws:acm:region:account:certificate/certificate-id

   # Verify DNS validation
   dig www.your-domain.com
   ```

2. **CloudFront Problems**

   ```sh
   # Invalidate cache
   aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"

   # Check distribution status
   aws cloudfront get-distribution --id YOUR_DISTRIBUTION_ID
   ```

3. **S3 Access Issues**
   - Verify bucket policy
   - Check CloudFront OAC settings
   - Confirm bucket name matches domain

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 3.4. CI/CD Pipeline

The included Jenkins pipeline automates deployment:

1. **Pipeline Setup**

   - Install required Jenkins plugins
   - Create new pipeline job
   - Configure GitHub webhook
   - Point to Jenkinsfile

2. **Pipeline Stages**
   - Build
   - Test
   - Deploy infrastructure
   - Deploy website
   - Verification

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### 3.5. Cleanup

```sh
# Remove infrastructure
docker-compose run --rm terraform destroy

# Clean Docker resources
docker-compose down -v
docker system prune -f

# Remove local files
rm -rf .terraform
rm -rf terraform.tfstate*
```

<!-- _For more examples, please refer to the [Documentation](https://www.jdnguyen.net)_ -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## 4. Roadmap

- [ ] Jenkins Deploy
  - Implement automated deployment using Jenkins CI/CD pipeline
- [ ] Terraform State Management
  - Implement state persistence in S3 for better collaboration and versioning
- [x] CloudFront Integration
  - [x] Set up CloudFront distribution for content delivery
  - [x] Configure Origin Access Control for enhanced security
  - [x] Implement public access blocking for S3 origin
  - [x] Integrate AWS Certificate Manager for HTTPS
  - [x] Configure Route 53 for domain management

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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 6. License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## 7. Contact

Jonathan Nguyen - jonathan@jdnguyen.tech

Project Link: [https://github.com/jonathan-d-nguyen/portfolio-devops_resume](https://github.com/jonathan-d-nguyen/portfolio-devops_resume)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

## 8. Acknowledgments

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
