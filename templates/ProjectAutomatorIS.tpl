<?xml version="1.0" encoding="UTF-8"?>
<DeployerSpec exitOnError="true" sourceType="Repository">
	<DeployerServer>
		<host>@DEPLOYER_HOST@:@DEPLOYER_PORT@</host>
		<user>@DEPLOYER_USER@</user>
		<pwd>@DEPLOYER_PWD@</pwd>
	</DeployerServer>
  <Environment>
		<IS>
			<isalias name="@IS_TARGET_ALIAS@">
				<host>@IS_TARGET_HOST@</host>
				<port>@IS_TARGET_PORT@</port>
				<user>@IS_TARGET_USER@</user>
				<pwd>@IS_TARGET_PWD@</pwd>
				<useSSL>false</useSSL>
				<version>@IS_VERSION@</version>
				<installDeployerResource>true</installDeployerResource>
				<Test>true</Test>
			</isalias>
		</IS>
		<Repository>
			<repalias name="@DEPLOYER_REPO_NAME@">
				<type>FlatFile</type>
				<urlOrDirectory>@DEPLOYER_REPO_PATH@</urlOrDirectory>
				<Test>false</Test>
			</repalias>
		</Repository>	
	</Environment>

	<Projects projectPrefix="">
		<Project description="Deployment of IS artefacts" name="@IS_PROJECT_NAME@" overwrite="true" type="Repository">
			<ProjectProperties>
				<Property name= "projectLocking">false</Property>
				<Property name= "concurrentDeployment">true</Property>
				<Property name= "ignoreMissingDependencies">true</Property>
				<Property name= "isTransactionalDeployment">true</Property>
			</ProjectProperties>

			<DeploymentSet autoResolve="ignore" description="IS Deployment Set" name="@IS_DEPSET_NAME@" srcAlias="@DEPLOYER_REPO_NAME@">
				<!--  The Composite and Component Constructs are independant of the Namespace Types. The Project Automator will support all the Namespace Types -->		
				<Composite name="*" srcAlias="@DEPLOYER_REPO_NAME@" type="*"/>
			</DeploymentSet>
			<DeploymentMap description="IS Deployment Map" name="@IS_DEPMAP_NAME@"/>			
			<MapSetMapping mapName="@IS_DEPMAP_NAME@" setName="@IS_DEPSET_NAME@">				
				<alias type="IS">@IS_TARGET_ALIAS@</alias>
			</MapSetMapping>
			<DeploymentCandidate description="IS Deployment Candidate" mapName="@IS_DEPMAP_NAME@" name="@IS_DEPCAN_NAME@"/>
		</Project>
	</Projects>
</DeployerSpec>
