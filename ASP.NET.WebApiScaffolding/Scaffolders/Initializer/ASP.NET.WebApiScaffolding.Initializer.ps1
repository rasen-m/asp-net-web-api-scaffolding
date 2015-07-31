[T4Scaffolding.Scaffolder(Description = "Makes a blank Initializer")][CmdletBinding()]
param(        
	[string]$DbContextType,
	[string]$Area,
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders
)

if (!$DbContextType) {
	$defaultNamespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value
	$DbContextType = $defaultNamespace + "Context"
	Write-Host "No DbContext provided ... Guessing " $DbContextType
}

$foundDbContextType = Get-ProjectType $DbContextType -Project $Project -AllowMultiple
if (!$foundDbContextType) { 
	Write-Host "DbContext not found. Abort generating Initializer..."
	return 
}

Write-Host "Scaffolding Initializer..."

$foundInitializer = Get-ProjectType ($defaultNamespace + "Initializer") -Project $Project -AllowMultiple

if (!$foundInitializer) {
	# Determine where the Initializer will go
	$initializerType = $defaultNamespace + "Initializer"
	$outputPath = Join-Path DataAccessLayer $initializerType

	if ($Area) {
		$areaFolder = Join-Path Areas $Area
		if (-not (Get-ProjectItem $areaFolder -Project $Project)) {
			Write-Error "Cannot find area '$Area'. Make sure it exists already."
			return
		}
		$outputPath = Join-Path $areaFolder $outputPath
	}

	$defaultNamespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value
	$modelTypeNamespace = $defaultNamespace + ".Models"
	$dbContextNamespace = [T4Scaffolding.Namespaces]::Normalize($defaultNamespace + "." + [System.IO.Path]::GetDirectoryName($outputPath).Replace([System.IO.Path]::DirectorySeparatorChar, "."))

	Add-ProjectItemViaTemplate $outputPath `
		-Template InitializerTemplate `
		-Model @{
			DefaultNamespace = $defaultNamespace; 
			ModelTypeNamespace = $modelTypeNamespace; 
			DbContextNamespace = $dbContextNamespace; 
			InitializerType = $initializerType;
			DbContextType = $DbContextType; 
		} `
		-SuccessMessage "Added initializer '{0}'" `
		-TemplateFolders $TemplateFolders `
		-Project $Project `
		-CodeLanguage $CodeLanguage `
		-Force:$Force

	$foundInitializer = Get-ProjectType ($defaultNamespace + "Initializer") -Project $Project -AllowMultiple
	if (!$foundInitializer) { 
		throw "Created Initializer, but could not find it as a project item" 
	}
}

return @{
	DbContextType = $foundDbContextType
}