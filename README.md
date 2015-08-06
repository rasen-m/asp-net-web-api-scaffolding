ASP.NET Web API Scaffolding
=========================

**AWAS** is a simple, opinionated code generation package for ASP.NET built on top of [T4Scaffolding][0]. AWAS allows you to quickly scaffold the standard boilerplates for Web API Controllers, Services, Repositories based on a provided Entity model.

[GitHub][1]

[NuGet][2]


Dependencies
------------
T4Scaffolding (≥ 1.0.8)


Installation
----------------
- Open the *Package Manager Console Window*:

  ```
  Tools > Library Package Manager > Package Manager Console
  ```
  
- Run the follwing command:

  ```
  Install-Package ASP.NET.WebApiScaffolding
  ```


Usage
----------------
All commands are executed in Package Manager Console after installation.

####To generate a Web API Controller for `Student`
```
Scaffold WebApiController Student
```
**This will also automatically generate the DbContext and Service for `Student`, to disable such behaviour use the `-NoChildItems` flag.*

**The Web API Controller and all child items generated are based on the [Service Layer Pattern][3], to generate based on [Repository Pattern][4] instead use the `-Repository` flag.*


####To generate a Service for `Student`
```
Scaffold Service Student
```
**As above.*


####To generate a Repository for `Student`
```
Scaffold Repository Student
```
**This command obviously do not have the `-Repository` flag*

####Optional Flags

|Flags|Behavior
|:---|:---
|`-Repository`|Switch to [Repository Pattern][4] for generated boilerplates
|`-NoChildItems`|Do not generate any other dependencies automatically
|`-Force`|Overwrite existing file if exists
	
	
All Commands
------------
```
Scaffold WebApiController <ModelType> [-Project] [-CodeLanguage] [-DbContextType] [-Area] [-NoChildItems] [-Repository] [-TemplateFolders] [-Force]

Scaffold Service <ModelType> [-Project] [-CodeLanguage] [-DbContextType] [-Area] [-NoChildItems] [-Repository] [-TemplateFolders] [-Force]

Scaffold Repository <ModelType> [-Project] [-CodeLanguage] [-DbContextType] [-Area] [-NoChildItems] [-TemplateFolders] [-Force]

Scaffold DbContext <ModelType> [-Project] [-CodeLanguage] [-DbContextType] [-Area] [-NoChildItems] [-TemplateFolders] [-Force]
```
```
<required parameter>
[-optional flag]
```
	
Layers
------
Assuming we are working with a model called `Student`, AWAS will generate boilerplates based on the [Service Layer Pattern][3]. For a given model, the stack will be as follows:

|**StudentController**
:---:
|**StudentService**

Alternatively, you can add the `-Repository` flag to generate boiletplates based on the [Repository Pattern][4], the stack will be as follows:

|**StudentController**
:---:
|**StudentService**
|**StudentRepository**


Folder Structure
----------------
```
Project\
	Controllers\
		StudentController.cs
		CourseController.cs
		...
	DataAccessLayer\
		ProjectContext.cs
		ProjectInitializer.cs
	Repositories\
		StudentRepository.cs
		CourseRepository.cs
		...
	Services\
		StudentService.cs
		CourseService.cs
		...
```


Additional Notes
----------------
- The package is built on top of [T4Scaffolding][0], therefore most of the features and flags of T4Scaffolding are also available. Most notably, **CustomScaffolder** and **CustomTemplate**.


[0]: http://www.nuget.org/packages/T4Scaffolding/
[1]: https://www.nuget.org/packages/ASP.NET.WebApiScaffolding/
[2]: https://www.nuget.org/packages/ASP.NET.WebApiScaffolding/
[3]: https://en.wikipedia.org/wiki/Service_layers_pattern
[4]: https://msdn.microsoft.com/en-us/library/ff649690.aspx