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

# Would ActiveRecord work?

@@@ ruby
    class Account < ActiveRecord::Base
      named_scope :rich,
        :conditions => 'balance >= 1000'
      named_scope :poor,
        :conditions => 'balance < 100'
    end
@@@

!SLIDE

# DataMapper

@@@ ruby
    class Account
      include DataMapper::Resource
      property :id, Serial
      property :balance, Integer
      
      def self.rich
        all(:balance.gte => 1000)
      end
      def self.poor
        all(:balance.lte => 100)
      end
    end
@@@

!SLIDE

# Datastore

!SLIDE

# Schemaless?

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

# Relationships

@@@ ruby
    class User
      include DataMapper::AppEngineResource
      belongs_to_entity :user
      has n, :children
    end
@@@

!SLIDE

# Idempotence
## Or, "Why can't I click submit more than once?"