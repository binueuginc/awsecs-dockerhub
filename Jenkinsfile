def gv
pipeline {
   agent any
     parameters {
	    choice (name: 'VERSION', choices: ['1.0.1', '1.2.0', '1.3.0'], description: 'Deployment of selected version')
		booleanParam(name: 'executeTest', defaultValue: true, description: '')
	        choice (name: 'BRANCH', choices: ['master', 'prod', 'dev', 'sanity'], description: 'Deployment Git Branch  selected')
	        booleanParam(name: 'executeDeploy', defaultValue: false, description: '')
	        choice (name: 'TEAM', choices: ['NOC', 'R&D'], description: 'Deployment Git Branch  selected')
	        booleanParam(name: 'executeDockerPush', defaultValue: false, description: '')
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
			     BRANCH_NAME == "${params.BRANCH}" 
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
		stage('dockerDeploy'){
		   when {
		      expression {
			      params.executeDeploy == true && BRANCH_NAME == "${params.BRANCH}"
				 }
		    }
		   steps{
			   script {
		               gv.dockerDeployApp()
			   }
             }
		}
     }		
}
