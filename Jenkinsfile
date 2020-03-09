def props
def sag_home
def abe_home
def jenkins_ws
def module
def branch_prefix
def build_version
def mode
def enable_is_build
def is_asset_prefix
def enable_tn_build
def target_env
def branch
def branch_source
def branch_source_path
def git_credentials
def Administrator
def Password
def git_url_id
def git_url
def branch_build_path
def deployer_home
def deployer_host
def deployer_port
def deployer_user
def deployer_password
def project_name
def dep_repo_name
def dep_set_is
def dep_map_is
def dep_can_is
def automator_file_is
def automator_tmpl_is
def target_alias
def target_host
def target_port
def target_user
def target_password
def target_version


pipeline {
	environment {
		sag_home="C:/SoftwareAG101"
	}
	
	agent any
	
	stages {
		stage('Set Environment') {
			steps {
				print " ------ Set environment variables ------"
				script {
				

					
					
					
					module = "${params.MODULE}"
					branch_prefix = "${params.BRANCH_PREFIX}"
					build_version = "${params.BUILD_VERSION}"
					mode = "${params.MODE}"
					enable_is_build = "${params.ENABLE_IS_BUILD}"
					enable_tn_build = "${params.ENABLE_TN_BUILD}"
					target_env = "${params.TARGET_ENV}"					
					branch = "${branch_prefix}"+"${build_version}"
					git_url_id = "$module"+"_git_url"
					packageName = "${params.PACKAGE_NAME}"
					
					props = readProperties file: 'properties/Jenkinsfile.properties'
					sag_home = props['sag_home']
					abe_home = props['abe_home']
					jenkins_ws = props['jenkins_ws']
					git_credentials = props['git_authid']
					Administrator = props['Administrator']
					Password = props['Password']
					git_url = props["$git_url_id"]
				
					branch_source_path = "$jenkins_ws"+"/"+"${module}"+"/"+"${packageName}"+"/source"
					branch_build_path = "$jenkins_ws"+"/"+"${module}"+"/"+"${packageName}"+"/build"+"/"+"$build_version"
					
					deployer_home = props['deployer_home']
					deployer_host = props['deployer_host']
					deployer_port = props['deployer_port']					
					deployer_user = props['deployer_user']
					deployer_password = props['deployer_password']

					project_name = "$module"+"_is_"+"$build_version"+"_project"
					dep_repo_name= "$module"+"_is_"+"$build_version"+"_repo"
					dep_set_is = props['dep_set_is']
					dep_map_is = props['dep_map_is']
					dep_can_is = props['dep_can_is']
					automator_file_is = props['automator_file_is']
					automator_tmpl_is = props['automator_tmpl_is']

					target_alias = props["$target_env"+'_alias_is']
					target_host = props["$target_env"+'_target_host_is']
					target_port = props["$target_env"+'_target_port_is']
					target_user = props["$target_env"+'_target_user_is']
					target_password = props["$target_env"+'_target_password_is']
					target_version = props["$target_env"+'_target_version_is']					
				}
				print " ------ $git_url ------"
			}
		}
		stage('Checkout Source code') {
			steps {
				print " ------ Checkout source code ------"
				gitCheckout("$branch_source_path", "$branch", "$git_credentials", "$git_url")
			}
		}

		stage('Build') {
			steps {
				script {
					if ("${mode}" == "Only_Build") {
						print " ------ Build Mode ------ ${mode}"
						createBuild("$sag_home","$abe_home","$build_version","$jenkins_ws","$branch_source_path", "$branch_build_path", "$enable_is_build","$enable_tn_build")
					} else if ("${mode}" == "Build_And_Deploy") {
						print " ------ Mode ------ ${mode}"
						createBuild("$sag_home","$abe_home","$build_version","$jenkins_ws","$branch_source_path", "$branch_build_path", "$enable_is_build","$enable_tn_build")						
					}
				}
			}
		}

		stage('Create Project') {
			steps {
				script {
					if ("${mode}" == "Only_Deploy") {
						print " ------ Create Project Mode ------ ${mode}"
						createProject("$sag_home","$jenkins_ws","$automator_file_is","$automator_tmpl_is","$deployer_home", "$deployer_host","$deployer_port","$deployer_user","$deployer_password","$project_name","$dep_set_is","$dep_map_is","$dep_can_is","$dep_repo_name","$branch_build_path","$target_alias","$target_host","$target_port","$target_user","$target_password","$target_version")
					} else if ("${mode}" == "Build_And_Deploy") {
						print " ------ Create Project Mode ------ ${mode}"
						createProject("$sag_home","$jenkins_ws","$automator_file_is","$automator_tmpl_is","$deployer_home", "$deployer_host","$deployer_port","$deployer_user","$deployer_password","$project_name","$dep_set_is","$dep_map_is","$dep_can_is","$dep_repo_name","$branch_build_path","$target_alias","$target_host","$target_port","$target_user","$target_password","$target_version")						
					}
				}
			}
		}
		stage('Deploy Build') {
			steps {
				script {
					if ("${mode}" == "Only_Deploy") {
						print " ------ Deploy Build Mode ------ ${mode}"
						deployBuild("$sag_home","$deployer_home","$project_name","$dep_can_is","$deployer_host","$deployer_port","$deployer_user","$deployer_password")
					} else if ("${mode}" == "Build_And_Deploy") {
						print " ------ Deploy Build Mode ------ ${mode}"
						deployBuild("$sag_home","$deployer_home","$project_name","$dep_can_is","$deployer_host","$deployer_port","$deployer_user","$deployer_password")						
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

def gitCheckout(branchDir, branchName, credentialsId, gitURL) {
	dir("$branchDir") {
		git branch: "$branchName", credentialsId: "$credentialsId", url: "$gitURL"
		bat 'del /F /Q .gitignore README.md'
		bat 'rd /S /Q .git'
	}
	
}

def createBuild(sagHome, abeHome, buildVersion, jenkinsWS, sourcePath, buildPath, enableIS, enableTN) {
	bat "$abeHome/bin/build.bat \
	-Dsag.install.dir=$sagHome \
	-Dbuild.source.dir=\"$sourcePath/esb;$sourcePath/tn;\" \
	-Dbuild.output.dir=$buildPath \
	-Denable.build.IS=$enableIS \
	-Denable.build.TN=$enableTN \
	-Dbuild.version=$buildVersion"	
}

def createProject(sagHome,jenkinsWS,projectAutomatorFile,projectAutomatorTemplate,deployerHome,deployerHost,deployerPort,deployerUser,deployerPassword,depProjectName,depSetName,depMapName,depCanName,depRepoName,depRepoPath,targetAlias,targetHost,targetPort,targetUser,targetPassword,targetVersion) {
	bat "$sagHome/common/lib/ant/bin/ant -file $jenkinsWS/sgt-tools/templates/build.xml createProjectReposiotry \
	-Dsag.install.dir=$sagHome \
	-Dautomator.file=$jenkinsWS/sgt-tools/templates/$projectAutomatorFile \
	-Dautomator.file.tpl=$jenkinsWS/sgt-tools/templates/$projectAutomatorTemplate \
	-Ddeployer.home=$sagHome/$deployerHome \
	-Ddeployer.host=$deployerHost \
	-Ddeployer.port=$deployerPort \
	-Ddeployer.user=$deployerUser \
	-Ddeployer.pwd=$deployerPassword \
	-Dis_proj.name=$depProjectName \
	-Dis_depset.name=$depSetName \
	-Dis_depmap.name=$depMapName \
	-Dis_depcan.name=$depCanName \
	-Dproj_repository.name=$depRepoName \
	-Dproj_repository.path=$depRepoPath \
	-Dis_target.alias=$targetAlias \
	-Dis_target.host=$targetHost \
	-Dis_target.port=$targetPort \
	-Dis_target.user=$targetUser \
	-Dis_target.pwd=$targetPassword \
	-Dis.version=$targetVersion"
}

def deployBuild(sagHome, deployerHome, projectName, depCanName, deployerHost,deployerPort,deployerUser,deployerPassword) {
	bat "$sagHome/$deployerHome/bin/Deployer.bat --deploy \
	-project $projectName \
	-dc $depCanName \
	-host $deployerHost \
	-port $deployerPort \
	-user $deployerUser \
	-pwd $deployerPassword"
}



