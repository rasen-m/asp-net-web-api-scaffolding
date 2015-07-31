[T4Scaffolding.Scaffolder(Description = "Create a WebApiController for a Model that uses the Model's Service")][CmdletBinding()]
param(        
	[parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ControllerName,   
	[string]$ModelType,
    [string]$Project,
	[string]$CodeLanguage,
	[string]$DbContextType,
	[string]$Area,
	[string]$Service,
	[switch]$NoChildItems = $false,
	[string[]]$TemplateFolders,
	[switch]$Force = $false,
	[string]$ForceMode
)
 
# Interpret the "Force" and "ForceMode" options
$overwriteController = $Force -and ((!$ForceMode) -or ($ForceMode -eq "ControllerOnly"))
$overwriteFilesExceptController = $Force -and ((!$ForceMode) -or ($ForceMode -eq "PreserveController"))

# If you haven't specified a model type, we'll guess from the controller name
if (!$ModelType) {
	if ($ControllerName.EndsWith("Controller", [StringComparison]::OrdinalIgnoreCase)) {
		# If you've given "PeopleController" as the full controller name, we're looking for a model called People or Person
		$ModelType = [System.Text.RegularExpressions.Regex]::Replace($ControllerName, "Controller$", "", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
		$foundModelType = Get-ProjectType $ModelType -Project $Project -ErrorAction SilentlyContinue
		if (!$foundModelType) {
			$ModelType = [string](Get-SingularizedWord $ModelType)
			$foundModelType = Get-ProjectType $ModelType -Project $Project -ErrorAction SilentlyContinue
		}
	} else {
		# If you've given "people" as the controller name, we're looking for a model called People or Person, and the controller will be PeopleController
		$ModelType = $ControllerName
		$foundModelType = Get-ProjectType $ModelType -Project $Project -ErrorAction SilentlyContinue
		if (!$foundModelType) {
			$ModelType = [string](Get-SingularizedWord $ModelType)
			$foundModelType = Get-ProjectType $ModelType -Project $Project -ErrorAction SilentlyContinue
		}
		if ($foundModelType) {
			$ControllerName = [string](Get-PluralizedWord $foundModelType.Name) + "Controller"
		}
	}
	if (!$foundModelType) { throw "Cannot find a model type corresponding to a controller called '$ControllerName'. Try supplying a -ModelType parameter value." }
} else {
	# If you have specified a model type
	$foundModelType = Get-ProjectType $ModelType -Project $Project
	if (!$foundModelType) { return }
	if (!$ControllerName.EndsWith("Controller", [StringComparison]::OrdinalIgnoreCase)) {
		$ControllerName = $ControllerName + "Controller"
	}
}
Write-Host "Scaffolding $ControllerName..."

# Get DbContextType if not provided
if(!$DbContextType) { 
	$DbContextType = [System.Text.RegularExpressions.Regex]::Replace((Get-Project $Project).Name, "[^a-zA-Z0-9]", "") + "Context" 
}

# Attempt to generate Service and DbContext if $NoChildItems is not flagged
if (!$NoChildItems) {
	if (!$Service) {
		Scaffold Service -ModelType $foundModelType.FullName -DbContextType $DbContextType -Area $Area -Project $Project -CodeLanguage $CodeLanguage -Force:$overwriteFilesExceptController
	} else {
		$dbContextScaffolderResult = Scaffold DbContext -ModelType $foundModelType.FullName -DbContextType $DbContextType -Area $Area -Project $Project -CodeLanguage $CodeLanguage
		$foundDbContextType = $dbContextScaffolderResult.DbContextType
		if (!$foundDbContextType) { 
			return 
		}
	}
}

if (!$foundDbContextType) { 
	$foundDbContextType = Get-ProjectType $DbContextType -Project $Project 
}

if (!$foundDbContextType) { 
	return 
}

# Ensure Primary Key of provided Model is retrievable 
$primaryKey = Get-PrimaryKey $foundModelType.FullName -Project $Project -ErrorIfNotFound
if (!$primaryKey) { 
	return 
}

# File path. The filename extension will be added based on the template's <#@ Output Extension="..." #> directive
$outputPath = Join-Path Controllers ($foundModelType.Name + "Controller") 

# Override the default path for the scaffolded file if $Area is provided
if ($Area) {
	$areaFolder = Join-Path Areas $Area
	if (-not (Get-ProjectItem $areaFolder -Project $Project)) {
		Write-Error "Cannot find area '$Area'. Make sure it exists already."
		return
	}
	
	$outputPath = Join-Path $areaFolder $outputPath
}

# Prepare all the parameter values to pass to the template, then invoke the template with those values
$serviceName = $foundModelType.Name + "Service"
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value
$modelTypeNamespace = [T4Scaffolding.Namespaces]::GetNamespace($foundModelType.FullName)
$controllerNamespace = [T4Scaffolding.Namespaces]::Normalize($namespace + "." + [System.IO.Path]::GetDirectoryName($outputPath).Replace([System.IO.Path]::DirectorySeparatorChar, "."))
$areaNamespace = if ($Area) { [T4Scaffolding.Namespaces]::Normalize($namespace + ".Areas.$Area") } else { $namespace }
$dbContextNamespace = $foundDbContextType.Namespace.FullName
$servicesNamespace = [T4Scaffolding.Namespaces]::Normalize($areaNamespace + ".Services")
$modelTypePluralized = Get-PluralizedWord $foundModelType.Name
$relatedEntities = [Array](Get-RelatedEntities $foundModelType.FullName -Project $project)
if (!$relatedEntities) { $relatedEntities = @() }

Add-ProjectItemViaTemplate $outputPath `
	-Template WebApiControllerTemplate `
	-Model @{ 
		ControllerName = $ControllerName;
		ModelType = [MarshalByRefObject]$foundModelType; 
		PrimaryKey = [string]$primaryKey; 
		Namespace = $namespace; 
		AreaNamespace = $areaNamespace; 
		DbContextNamespace = $dbContextNamespace;
		ServicesNamespace = $servicesNamespace;
		ModelTypeNamespace = $modelTypeNamespace; 
		ControllerNamespace = $controllerNamespace; 
		DbContextType = [MarshalByRefObject]$foundDbContextType;
		Service = $serviceName; 
		ModelTypePluralized = [string]$modelTypePluralized; 
		RelatedEntities = $relatedEntities;
	} `
	-SuccessMessage "Added WebApiControllerWithService output at {0}" `
	-TemplateFolders $TemplateFolders `
	-Project $Project `
	-CodeLanguage $CodeLanguage `
	-Force:$Force