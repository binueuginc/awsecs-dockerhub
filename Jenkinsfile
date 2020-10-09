def gv
pipeline {
   agent any
     parameters {
	    choice (name: 'VERSION', choices: ['1.0.1', '1.2.0', '1.3.0'], description: 'Deployment of selected version')
	        booleanParam(name: 'executeBuild', defaultValue: false, description: '')
		booleanParam(name: 'executeTest', defaultValue: true, description: '')
	        choice (name: 'BRANCH', choices: ['master', 'prod', 'dev', 'sanity'], description: 'Deployment Git Branch  selected')
	        booleanParam(name: 'executeDockerPush', defaultValue: false, description: '')
	        booleanParam(name: 'executeTestDeploy', defaultValue: false, description: '')
	        booleanParam(name: 'executeAwsEcsDeploy', defaultValue: false, description: '')
	        booleanParam(name: 'executeCleanUp', defaultValue: false, description: '')
	        booleanParam(name: 'executeDockerClean', defaultValue: true, description: '')
		}
	environment {
		DOCKERRUN = "docker run -p 8080:8080 my-app binueuginc/sample-myapp:${params.VERSION} " 
		DOCKERCLEAN = "docker images  | awk '{print \$1 \":\" \$2}' | xargs docker rmi -f"
                TASK_FAMILY = "sample-myapp-task"
                SERVICE_NAME = "sample-myapp-service"
                NEW_DOCKER_IMAGE = "sample-myapp:${params.VERSION}"
                CLUSTER_NAME = "sample-myapp-cluster"
                OLD_TASK_DEF = "aws ecs describe-task-definition --task-definition ${env.TASK_FAMILY} --output json"
                NEW_TASK_DEF= "echo ${env.OLD_TASK_DEF} | jq --arg NDI ${env.NEW_DOCKER_IMAGE} '.taskDefinition.containerDefinitions[0].image=$NDI'"
                FINAL_TASK = "echo ${env.NEW_TASK_DEF} | jq '.taskDefinition|\{family: .family, volumes: .volumes, containerDefinitions: .containerDefinitions\}'"
                
	}
         stages {
	    stage('init'){
	     steps {
		   script {
		   gv = load "groovy.script"
		      } 
		   }
	    }
		
	   stage('build') {
	      when {
		     expression {
			     BRANCH_NAME == "${params.BRANCH}" && params.executeBuild == true 
				}
			}	
	      steps {
		      script {
			      gv.dockerBuild()
		      }
		
		  }
		}
		stage('test'){
		   when {
		      expression {
			     params.executeTest == true 
				 }
		   }
		   steps{
			   script {
		               gv.testApp()
			 }
		     }
		}
		 stage('dockerPush'){
		   when {
		      expression {
			      params.executeDockerPush == true 
				 }
		    }
		   steps{
			   script {
		               gv.dockerPush()
			   }
                   }
		}
		stage('dockerTestDeploy'){
		   when {
		      expression {
			      params.executeTestDeploy == true && BRANCH_NAME == "${params.BRANCH}"
				 }
		    }
		   steps{
			   script {
		               gv.dockerDeployApp()
			   }
             }
		}
		stage('awsEcsDeploy'){
		   when {
		      expression {
			      params.executeAwsEcsDeploy == true 
				 }
		    }
		   steps{
			   script {
		               gv.dockerEcsDeployApp()
			   }
             }
		}
	    stage('dockerImagesCleanUp'){
		when {
		   expression {
			 params.executeDockerClean == true 
			     }
		     }
		   steps{
		      script {
		          gv.dockerCleanup()
			   }
                   }
	    }
     }	
    post {
   
        cleanup {
            /* clean up our workspace */
            deleteDir()
            /* clean up tmp directory */
            dir("${workspace}@tmp") {
                deleteDir()
            }
            /* clean up script directory */
            dir("${workspace}@script") {
                deleteDir()
            }
        }
    }
}
