pipeline {
	agent any
	tools {
		nodejs 'NodeJS'
	}
	environment {
		SONAR_PROJECT_KEY = 'complete-cicd-02'
		SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
		JOB_NAME_NOW = 'cicd02'
		ECR_REPO = 'iquantawsrepo'
		IMAGE_TAG = 'latest'
		ECR_REGISTRY = '358966077154.dkr.ecr.us-east-1.amazonaws.com'
		ECS_CLUSTER = 'iquant-ecs'
		ECS_SERVICE = 'iquant-ecs-svc'
		ALB_TARGET_GROUP_ARN = 'ecs-iquant-svc-tg'
	}
	stages {
		stage('GitHub'){
			steps {
				git branch: 'main', credentialsId: 'jen-git-dind', url: 'https://github.com/iQuantC/Complete_CICD_02.git'
			}
		}
		stage('Unit Test'){
			steps {
				sh 'npm test'
				sh 'npm install'		
			}
		}
		stage('SonarQube Analysis'){
			steps {
				withCredentials([string(credentialsId: 'complete-cicd-02-token', variable: 'SONAR_TOKEN')]) {
    					
					withSonarQubeEnv('SonarQube') {
    						sh """
						${SONAR_SCANNER_HOME}/bin/sonar-scanner \
						-Dsonar.projectKey=${SONAR_PROJECT_KEY} \
						-Dsonar.sources=. \
						-Dsonar.host.url=http://sonarqube-dind:9000 \
						-Dsonar.login=${SONAR_TOKEN}
						"""
					}
				}
			}
		}
		stage('Docker Image'){
			steps {
				script {
					docker.build("${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}")
				}
			}
		}
		stage('Trivy Scan'){
			steps {
				sh 'trivy --severity HIGH,CRITICAL --no-progress --format table -o trivy-report.html image ${JOB_NAME_NOW}:latest'
			}
		}
		stage('Login to ECR'){
			steps {
				sh """
				aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 358966077154.dkr.ecr.us-east-1.amazonaws.com
				"""
			}
		}
		stage('Push Image to ECR'){
			steps {
				script {
				docker.image("${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}").push()
				}
			}
		}
	}
}