# pixabay_prj

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.











# Deploying a Flutter Web Project with Jenkins and GitHub

## Prerequisites
1. Flutter SDK installed on the Jenkins server
2. Git installed on the Jenkins server
3. Jenkins installed and running
4. GitHub account and repository for your Flutter project
5. GitHub Personal Access Token (PAT) for Jenkins to access your repository

## Step 1: Prepare Your Flutter Project
1. Ensure your Flutter project is set up for web:
   ```
   flutter create .
   flutter config --enable-web
   ```
2. Test your web build locally:
   ```
   flutter build web
   ```
3. Commit and push your project to GitHub.

## Step 2: Set Up Jenkins
1. Install necessary Jenkins plugins:
   - Git plugin
   - GitHub plugin
   - Credentials plugin

2. Add GitHub credentials to Jenkins:
   - Go to "Manage Jenkins" > "Manage Credentials"
   - Add a new credential of type "Username with password"
   - Use your GitHub username and PAT as the password

## Step 3: Create a Jenkins Pipeline
1. In Jenkins, create a new Pipeline job.
2. Configure the pipeline to use your GitHub repository:
   - Under "Pipeline", select "Pipeline script from SCM"
   - Choose Git as the SCM
   - Enter your repository URL
   - Select the credentials you added earlier

3. Create a `Jenkinsfile` in your project root with the following content:

```groovy
pipeline {
    agent any
    
    environment {
        FLUTTER_HOME = '/path/to/flutter'
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Flutter Doctor') {
            steps {
                sh 'flutter doctor'
            }
        }
        
        stage('Get Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }
        
        stage('Build Web') {
            steps {
                sh 'flutter build web --release'
            }
        }
        
        stage('Deploy to GitHub Pages') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh """
                            cd build/web
                            git init
                            git config user.email "jenkins@example.com"
                            git config user.name "Jenkins"
                            git add .
                            git commit -m "Deploy web build"
                            git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/yourusername/your-repo.git HEAD:gh-pages
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
```

Replace `/path/to/flutter` with the actual path to your Flutter SDK on the Jenkins server.

## Step 4: Configure GitHub Repository
1. In your GitHub repository, go to "Settings" > "Pages"
2. Set the source to the `gh-pages` branch

## Step 5: Run the Jenkins Pipeline
1. In Jenkins, go to your pipeline job and click "Build Now"
2. Jenkins will clone your repository, build the Flutter web project, and deploy it to GitHub Pages

## Step 6: Access Your Deployed Web App
Your Flutter web app should now be accessible at `https://yourusername.github.io/your-repo-name/`

## Troubleshooting
- If the build fails, check the Jenkins console output for error messages
- Ensure all paths in the Jenkinsfile are correct for your setup
- Verify that the GitHub PAT has the necessary permissions (repo access)
- Check that the Flutter SDK is properly installed and accessible on the Jenkins server

## Security Considerations
- Use Jenkins' credential management for sensitive information
- Regularly update your GitHub PAT and Jenkins plugins
- Consider using webhook triggers instead of polling for better security and performance

## Optimization Tips
- Use caching in Jenkins to speed up dependency fetching
- Consider implementing automated tests in your pipeline before deployment
- Set up notifications for successful/failed builds

Remember to adjust file paths, repository URLs, and credentials as needed for your specific setup.



















# Detailed Prerequisites for Flutter Web Deployment with Jenkins and GitHub

## 1. Installing Flutter SDK on the Jenkins Server

1.1. Download Flutter:
   - Visit the official Flutter website: https://flutter.dev/docs/get-started/install
   - Choose the appropriate version for your Jenkins server's operating system
   - Download the Flutter SDK zip file

1.2. Extract Flutter:
   - Create a directory for Flutter, e.g., `/opt/flutter`
   - Extract the downloaded zip file to this directory
   ```
   sudo mkdir /opt/flutter
   sudo unzip ~/Downloads/flutter_linux_3.x.x-stable.zip -d /opt/flutter
   ```

1.3. Set up PATH:
   - Add Flutter to your PATH by editing `/etc/environment` or `/etc/profile`
   ```
   sudo nano /etc/environment
   ```
   - Add the following line:
   ```
   PATH="/opt/flutter/flutter/bin:$PATH"
   ```
   - Save and exit the file

1.4. Verify installation:
   - Log out and log back in, or restart the server
   - Run `flutter doctor` to verify the installation and identify any missing dependencies
   ```
   flutter doctor
   ```

1.5. Install any missing dependencies identified by `flutter doctor`

## 2. Installing Git on the Jenkins Server

2.1. Update package lists:
   ```
   sudo apt update
   ```

2.2. Install Git:
   ```
   sudo apt install git
   ```

2.3. Verify Git installation:
   ```
   git --version
   ```

2.4. Configure Git globally (optional):
   ```
   git config --global user.name "Jenkins Server"
   git config --global user.email "jenkins@your-domain.com"
   ```

## 3. Installing and Running Jenkins

3.1. Install Java (Jenkins requires Java):
   ```
   sudo apt update
   sudo apt install openjdk-11-jdk
   ```

3.2. Add Jenkins repository key:
   ```
   wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
   ```

3.3. Add Jenkins repository to sources list:
   ```
   sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
   ```

3.4. Update package lists:
   ```
   sudo apt update
   ```

3.5. Install Jenkins:
   ```
   sudo apt install jenkins
   ```

3.6. Start Jenkins service:
   ```
   sudo systemctl start jenkins
   ```

3.7. Enable Jenkins to start on boot:
   ```
   sudo systemctl enable jenkins
   ```

3.8. Check Jenkins status:
   ```
   sudo systemctl status jenkins
   ```

3.9. Open firewall for Jenkins (if applicable):
   ```
   sudo ufw allow 8080
   ```

3.10. Access Jenkins web interface:
   - Open a web browser and navigate to `http://your-server-ip:8080`
   - Follow the on-screen instructions to complete the setup
   - Retrieve the initial admin password:
     ```
     sudo cat /var/lib/jenkins/secrets/initialAdminPassword
     ```

## 4. Setting up GitHub Account and Repository

4.1. Create GitHub account:
   - Go to https://github.com
   - Click "Sign up" and follow the registration process

4.2. Create a new repository:
   - Click the "+" icon in the top-right corner
   - Select "New repository"
   - Name your repository
   - Choose public or private
   - Initialize with a README if desired
   - Click "Create repository"

4.3. Clone the repository locally:
   ```
   git clone https://github.com/your-username/your-repo-name.git
   ```

4.4. Add your Flutter project files to the repository:
   - Copy your Flutter project files into the cloned directory
   - Stage the files:
     ```
     git add .
     ```
   - Commit the files:
     ```
     git commit -m "Initial commit of Flutter project"
     ```
   - Push to GitHub:
     ```
     git push origin main
     ```

## 5. Creating a GitHub Personal Access Token (PAT)

5.1. Log in to your GitHub account

5.2. Click on your profile picture in the top-right corner

5.3. Go to "Settings"

5.4. In the left sidebar, click on "Developer settings"

5.5. Click on "Personal access tokens"

5.6. Click "Generate new token"

5.7. Give your token a descriptive name

5.8. Select the following scopes:
   - repo (all)
   - admin:repo_hook
   - read:user
   - user:email

5.9. Click "Generate token"

5.10. Copy the generated token immediately (you won't be able to see it again)

5.11. Store the token securely (you'll need it for Jenkins configuration)

## Additional Steps

- Ensure the Jenkins user has the necessary permissions to run Flutter and Git commands
- Consider setting up SSH keys for more secure GitHub authentication
- Regularly update Flutter, Git, and Jenkins to their latest versions
- Implement proper security measures on your Jenkins server, such as:
  - Changing the default port
  - Setting up HTTPS
  - Implementing proper user management and access control