#From https://stackoverflow.com/questions/55461216/powershell-to-trigger-a-build-in-azure-devops
#Replace in variables branch name, build definition name, server name, project name

Function Queue-Build ($definitionName, $branchName)
{
    Write-Host "Building $definitionName - $branchName"
    $build = (vsts build queue --project [project_name] --instance [server_name] --definition-name $definitionName --branch $branchName) | Out-String | ConvertFrom-Json

    #wait for the build to complete
    while ($build.status -ne "completed") {
        Start-Sleep -s 5
        $build = (vsts build show --id $build.id --instance [server_name] --project [project_name]) | Out-String | ConvertFrom-Json
        Write-Host $build.status
    }
}

vsts login --token PAT_created_in_DevOps

$sourceBranch = [branch_name]
Queue-Build [build_definition_name] $sourceBranch 