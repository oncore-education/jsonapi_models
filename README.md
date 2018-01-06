# JsonapiModels

A set of rails generators that will create model files for front end frameworks based off of your db schema 
and active model serializers

TODO:
 * CoreData Models
 * Swift File Generation
 * Generic Models for Angular
 * React??
 * Ember??
 * Android??

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi_models'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonapi_models

## Requirements
The generated models only include attributes and relationships that are included in the serializers for each model.

If a model exists, but does not have a serializer it will be skipped

## Extra Attributes  
In some cases you may want to allow attributes to be pushed to the API, but not serialized from the API. For instance
you need to push `user.password`, but you shouldn't have `password` in the user serializer.  To include these
private attributes simply add a line like this to your serializer class:

```ruby
#push_attr password:string
#push_attr password_confirmation:string
```

## Usage

install initializers

    $ rails g jsonapi_models:install
    
Currently this gem only works to output Angular Models for use with the [angular2-jsonapi](https://github.com/ghidoz/angular2-jsonapi) 

* First set the ng_output in `initializers/jsonapi_models.rb`

generate models:

    $ rails g jsonapi_models:angular
    
Inspired by MOGenerator, two classes will be created for each model.  The machine generated class includes all of
the attributes and relationships. This file will be overwritten every time you generate models.

The other class extends the machine generated class and you can put custom model 
methods in there.  This file will only be written once.

## Output
For use with [angular2-jsonapi](https://github.com/ghidoz/angular2-jsonapi), you should set `config.ng_ouput` equal to 
`MyAngularApp/src/app` 

Two directories will be created only if they don't exist: `models` and `services`

This will handle creating the necessary `datastore` class as well which will initialize and import all of your models

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/oncore-education/jsonapi_models.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
