pipeline {
  agent any
  tools { 
        maven 'Maven_3_5_2'  
    }
   stages{ 
	   
  		
		stage('CompileandRunSonarAnalysis') {
            steps {	
		sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=therealilyas_devsecops-jenkins-k8s-tf-sast-sonarcloud-repo -Dsonar.organization=therealilyas -Dsonar.host.url=https://sonarcloud.io -Dsonar.token=4ab967958cb7a6f4338ae85627e912e68eb7f3af'
			}
    	}

		stage('RunSCAAnalysisUsingSnyk') {
	            steps {		
					withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
						sh 'mvn snyk:test -fn'
					}
				}
	    }

		stage('Build') { 
	            steps { 
	               withDockerRegistry([credentialsId: "dockerlogin", url: ""]) {
	                 script{
	                 app =  docker.build("devsecops")
	                 }
	               }
	            }
	    }

   

        stage('Push') {
            steps {
                script {
                    docker.withRegistry(
                        'https://422523651126.dkr.ecr.us-east-1.amazonaws.com',
                        'ecr:us-east-1:aws-credentials'
                    ) {
                        app.push('latest')
                    }
                }
            }
        }
	   
	stage('Kubernetes Deployment of ASG Bugg Web Application') {
	   steps {
	      withKubeConfig([credentialsId: 'kubelogin']) {
		  sh('kubectl delete all --all -n devsecops')
		  sh ('kubectl apply -f deployment.yaml --namespace=devsecops')
		}
	      }
   	}
	   
	// stage ('wait_for_testing'){
	//    steps {
	// 	   sh 'pwd; sleep 180; echo "Application Has been deployed on K8S"'
	//    	}
	//    }
	   
	// stage('RunDASTUsingZAP') {
 //          steps {
	// 	    withKubeConfig([credentialsId: 'kubelogin']) {
	// 			sh('zap.sh -cmd -quickurl http://$(kubectl get services/asgbuggy --namespace=devsecops -o json| jq -r ".status.loadBalancer.ingress[] | .hostname") -quickprogress -quickout ${WORKSPACE}/zap_report.html')
	// 			archiveArtifacts artifacts: 'zap_report.html'
	// 	    }
	//      }
 //    } 

	   
  }
}
