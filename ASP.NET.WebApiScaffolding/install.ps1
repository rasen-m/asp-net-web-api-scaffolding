param($rootPath, $toolsPath, $package, $project)

# Bail out if scaffolding is disabled (probably because you're running an incompatible version of NuGet)
if (-not (Get-Command Invoke-Scaffolder)) { return }

if ($project) { $projectName = $project.Name }
Get-ProjectItem "InstallationDummyFile.txt" -Project $projectName | %{ $_.Delete() }

Set-DefaultScaffolder -Name Service -Scaffolder ASP.NET.WebApiScaffolding.Service -SolutionWide -DoNotOverwriteExistingSetting

Set-DefaultScaffolder -Name WebApiController -Scaffolder ASP.NET.WebApiScaffolding.WebApiController -SolutionWide -DoNotOverwriteExistingSetting

Set-DefaultScaffolder -Name Initializer -Scaffolder ASP.NET.WebApiScaffolding.Initializer -SolutionWide -DoNotOverwriteExistingSetting

Set-DefaultScaffolder -Name DbContext -Scaffolder ASP.NET.WebApiScaffolding.DbContext

Set-DefaultScaffolder -Name Repository -Scaffolder ASP.NET.WebApiScaffolding.Repository