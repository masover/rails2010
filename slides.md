!SLIDE

# dm-appengine

!SLIDE

# Why appengine?

!SLIDE

# "That looks easy! I could automate that!"
 - Commandline is easy
 - Port to Windows?
   - Write an installer? Yuck!
   - What kind of UI?
 - Web app?
   - Who will host it?

!SLIDE

# Free to start with
 - Low overhead for me
 - Managed
 - Ruby, not PHP!
 - It's fun!

!SLIDE

# Datamapper

 - Community
   - Plugins
   - Validations
 - Works well with weird datastores
 - Works well with traditional datastores
   - That much easier to migrate, in either direction

!SLIDE

# Datastore

!SLIDE

# Schemaless

!SLIDE

@@@ ruby
    class User
      include DataMapper::AppEngineResource
      property :name, String
      property :email, Email
      ...
    end
@@@

!SLIDE

@@@ ruby
    module DataMapper
      module AppEngineResource
        def self.included(klass)
          klass.class_eval do
            include DataMapper::Resource
            is :entity
          end
        end
      end
    end
@@@

!SLIDE

# Relationships (sort of)

!SLIDE

@@@ ruby
    class User
      include DataMapper::AppEngineResource
      belongs_to_entity :user
      has n, :children
    end
@@@

!SLIDE

# Idempotence