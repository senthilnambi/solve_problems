# Solve Problems

Following are a list of problems that I've encountered, my thoughts about them and solutions, if any, to solving them.

This is inspired by Buckminster Fuller's "experiment, to find what a single individual [could] contribute to changing the world and benefiting all humanity." [Source](https://en.wikipedia.org/wiki/Buckminster_Fuller#Bankruptcy_and_depression)

## Rails folder structure (in progress)

### Problem

Looking at the folder of a Rails app you can tell that it is a Rails app, but not its function. The most important part of the app is hidden under models/ and controllers/. See Robert Martin's Architecture the Lost Years keynote for details.

### Solution

Following Jose Valim's https://gist.github.com/1942658, this app gives preference to the function (authentication/, repo_statistics/), while config details are hidden under rails/. This structure was meant to say 'I am a web app that does x and y and only incidentally uses Rails'.

````
|── Gemfile
├── Gemfile.lock
├── Readme
│── authentication
│   ├── sessions_controller.rb
│   ├── user.rb
│   └── users_controller.rb
│── repo_statistics
│   ├── repo.rb
│   └── repo_controller.rb
├── rails
│   ├── boot.rb
│   ├── log
│   │   ├── development.log
│   │   └── production.log
│   └── rack.ru
├── spec
│   └── acceptance
│   └── authentication_spec.rb
└── vendor
````

[Source](https://gist.github.com/2146566)

### Thoughts

* Is this viable in the long run?
* Can you tell what the app does?

## OpenAuth2 (solved)

### Problem

Current state of OAuth2 support in Ruby. Experienced the problem when working with Google Calendar V3 api. It was hell due to lack of docs of current implementations and relevant examples in Ruby.

### Solution

[OpenAuth2](http://senthilnambi.github.com/OpenAuth2). Inbuilt support for Google & Facebook apis. Fully documented and tested. Has GET/POST examples.

## Meta (solved for now)

### Problem

An outlet to showcase my thoughts. Need something more organized than a blog (categorically, not chronologically), visually appealling and editable with my favorite editor (vim).

My biggest problem with contemporary blogs are their 'fire and forget' nature. Recently written posts get all the attention, while earlier ones live a sad, lonely life under some rock.

### Solution

A markdown formatted Readme, viewed with [DocumentUp](http://documentup.com/#hosted), hosted with Github Pages.

### Thoughts

* [Timeless](http://timelessrepo.com/timeless) is another approach to solving the same problem.
* This approach will be problematic as the problems grow in size and complexity.
* Also when solution is not easily dedutable and takes trial and error process.

### Alternatives
 * Jekyll + Twitter Bootstrap - Didn't want to spend time learning those tech.
 * Posterous/Tumblr - Not organized categorically by default.

## Unsolved

1. An outlet to showcase my work related entires: codes, sites, thoughts etc.
  * Github + About section in this document should do the trick
  * Point senthilnambi.com to here
