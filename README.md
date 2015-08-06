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
    ...
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
    ...
```

Customization
-------------
Since the package is built on top of [T4Scaffolding][0], we can leverage the `CustomScaffolder` and `CustomTemplate` that T4Scaffolding provides. 

####Custom Scaffolder
Custom scaffolder allows us to create custom boiletplate scaffolder so that we can generate the same boiletplate easily.

To generate a custom scaffolder call `Foo`:
```
Scaffold CustomScaffolder Foo
```

A folder will be generated:
```
Project\
    ...
	CodeTemplates\
        Scaffolders\
            Foo\
                Foo.ps1
                FooTemplate.cs.t4
    ...
	
```

You can now customize the `Foo.ps1` and `FooTemplate.cs.t4` to your needs. To use your newly created custom scaffolder, run:
```
Scaffold Foo <parameters> [flags]
```

####Custom Template
Custom templates allows us to reuse the existing scaffolders that comes with T4Scaffolding and AWAS but with a template style of your choice. 

To generate a custom Template for `WebApiController`:
```
Scaffold CustomTemplate WebApiController WebApiControllerTemplate
```

A folder will be generated:
```
Project\
    ...
	CodeTemplates\
        Scaffolders\
            WebApiController\
                WebApiControllerTemplate.cs.t4
    ...
	
```

You can now customize `WebApiControllerTemplate.cs.t4` to your needs. As long as the custom template exists in the folder, the package will use your template for all WebApiController scaffolded:
```
Scaffold WebApiController <parameters> [flags]
```


[0]: http://www.nuget.org/packages/T4Scaffolding/
[1]: https://www.nuget.org/packages/ASP.NET.WebApiScaffolding/
[2]: https://www.nuget.org/packages/ASP.NET.WebApiScaffolding/
[3]: https://en.wikipedia.org/wiki/Service_layers_pattern
[4]: https://msdn.microsoft.com/en-us/library/ff649690.aspx
