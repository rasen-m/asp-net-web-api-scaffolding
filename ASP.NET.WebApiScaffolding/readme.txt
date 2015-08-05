ASP.NET.WenApiScaffolding
https://www.nuget.org/packages/ASP.NET.WebApiScaffolding/

Description:
A simple package to scaffold WebApi Controllers and Services for Code-First models for ASP.NET Entity Framework.  

Command:
Scaffold WebApiController <ControllerName> [-ModelType] [-Project] [-CodeLanguage] [-DbContextType] [-Area] [-NoChildItems] [-Repository] [-TemplateFolders] [-Force] [-ForceMode]

Scaffold Service <ModelType> [-Project] [-CodeLanguage] [-DbContextType] [-Area] [-NoChildItems] [-Repository] [-TemplateFolders] [-Force]

Required Parameters:
	- <ControllerName>: The name of the controller that will be generated
	  If [-ModelType] is not provided, the model name will be guess via the <ControllerName>.
	  Example:
				Scaffold WebApiController Student
				# This command will generate a StudentController for model Student

	- <ModelType>: The name of the model that a Service will be generated for
	  Example:
				Scaffold Service Student
				# This command will generate a StudentService for model Student

Dependencies:
	- T4Scaffolding version 1.0.8 or greater
