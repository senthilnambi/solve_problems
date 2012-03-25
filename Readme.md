# Solve Problems

Following are a list of problems that I've encountered, my thoughts about them and solutions, if any, to solving them.

This is inspired by Buckminster Fuller's "experiment, to find what a single individual [could] contribute to changing the world and benefiting all humanity." [Source](https://en.wikipedia.org/wiki/Buckminster_Fuller#Bankruptcy_and_depression)

## Being Creative
Status: in progress

### Problem

How to be more creative when solving problems?
How to get better at solving problems?
How to make the connections between two seemingly unrelated things?

### Thoughts

* Rich Hickley, the author of Clojure gave a very good talk on the subject. [Link](https://blip.tv/clojure/hammock-driven-development-4475586)
* Creative pauses.
* Read `How to Solve it` by George Polya.

## Ruby `$LOAD_PATH`
Status: unsolved

### Problem

Very confused about `require` and `require_relative` and the various way to require files and directorys.

## Understanding Rails
Status: in progress

### Problem

Trouble understanding Rails.

### Solution

Take apart Rails and note any interesting code/patterns.

### Thoughts

1. Starting with Rails initialization process.
  1. http://guides.rubyonrails.org/initialization.html is incredibly useful.

## Rails folder structure
Status: in progress

### Problem

Looking at the folder of a Rails app you can tell that it is a Rails app, but not its function. The most important part of the app is hidden under `models/` and `controllers/`. See Robert Martin's Architecture the Lost Years keynote for details.

### Solution

Following Jose Valim's https://gist.github.com/1942658, this app gives preference to the function (`authentication/` , `repo_statistics/`), while config details are hidden under `rails/`. This structure was meant to say 'I am a web app that does x and y and only incidentally uses Rails'.

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

See https://github.com/senthilnambi/solve_problems/tree/master/rails_folder_struct for example Rails app with above structure.

### Thoughts

1. Is this viable in the long run?
1. Can you tell what the app does?

## OpenAuth2
Status: solved

### Problem

Current state of OAuth2 support in Ruby. Experienced the problem when working with Google Calendar V3 api. It was hell due to lack of docs of current implementations and relevant examples in Ruby.

### Solution

[OpenAuth2](http://senthilnambi.github.com/OpenAuth2). Inbuilt support for Google & Facebook apis. Fully documented and tested. Has GET/POST examples.

## Meta
Status: solved for now

### Problem

An outlet to showcase my thoughts. Need something more organized than a blog (categorically, not chronologically), visually appealling and editable with my favorite editor (vim).

My biggest problem with contemporary blogs are their 'fire and forget' nature. Recently written posts get all the attention, while earlier ones live a sad, lonely life under some rock.

### Solution

A markdown formatted Readme, viewed with [DocumentUp](http://documentup.com/#hosted), hosted with Github Pages.

### Thoughts

1. [Timeless](http://timelessrepo.com/timeless) is another approach to solving the same problem.
1. This approach will be problematic as the problems grow in size and complexity.
1. Also when solution is not easily dedutable and takes trial and error process.

### Alternatives
 1. Jekyll + Twitter Bootstrap - Didn't want to spend time learning those tech.
 1. Posterous/Tumblr - Not organized categorically by default.

## Unsolved

1. An outlet to showcase my work related entires: codes, sites, thoughts etc.
  1. Github + About section in this document should do the trick
  1. Point senthilnambi.com to here

1. Fast Rails BDD
  1. Prefer pure ruby objects to ORM objects
    1. Extract out domain logic into standalone class/modules and unit test them like any Ruby class/module
    1. Compose domain logic object with db mapper object?
      1. Easier to test with mocks
  1. Load time of Rails and its libraries takes a good chunk of time
    1. ~2 secs
  1. Installing gems in vendor/ makes it a bit faster
  1. ~1.1 secs if you load only action_controller and test using rack/test
    1. Good for API only apps
  1. Subclass controllers from ActionController::Metal and include only required middlewares
  1. Since controller actions are simply rack endpoints, we can functional test with rack/test, which is much faster
  1. No more monolithic app, cut into multiple Rack apps
  1. DataMapper 2.0 is supposed to implement DataMapper pattern fully. See Virtus, Veritas libraries.
