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

# DataMapper

@@@ ruby
    class User
      property :id, Serial
      property :name, String
      property :email, String
    end

    User.create(:name => 'Nobody',
                :email => 'nobody@example.com')

    User.first(:email => 'nobody@example.com')

    User.auto_migrate! # on sqlite3, MySQL, etc
@@@

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
    require 'dm-appengine/is_entity'

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

@@@ ruby
    class User
      property :id, Key, :key => true
      
      property :ancestor, AncestorKey
      undef_method :ancestor
      undef_method :ancestor=
      
      belongs_to_entity :parent
      
      def parent_id
        id.parent
      end
      
      def descendants(type)
        type.all(:ancestor => id)
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
## or, "Why can't I click submit more than once?"

!SLIDE

# Transactions
 - Optimistic locking
 - Atomic
 - Only across entity-groups

!SLIDE

# Simple case is simple

@@@ ruby
    class Post
      include DataMapper::AppEngineResource
      property :hit_count, Integer,
          :default => 0
      
      def hit!
        transaction do
          reload
          self.hit_count += 1
          save
        end
      end
    end
@@@

!SLIDE

# Entity-groups

@@@ ruby
    class User
      include DataMapper::AppEngineResource
      property :name, String
      has_descendants :favorites
      
      def set_favorite! name, url
        transaction do
          reload
          fave = self.favorites.first(:name => name)
          current ||= Favorite.new(:id => {:parent_id => id})
          current.url = url
          current.save
        end
      end
    end
    
    class Favorite
      property :name, String
      property :url, String
    end
@@@

!SLIDE

# Global transactions
 - Don't do them!
 - Really, you don't need them!
 - They wouldn't scale anyway!
## but sometimes...

!SLIDE

# Inventory tracking

@@@ ruby
    class Item
      include Base
  
      property :name, String, :required => true
      property :description, Text
      property :stock, Integer, :default => 0
      
      has_descendants :item_transactions
      ...
    end
    
    class ItemTransaction
      include Base
  
      property :count, Integer, :default => 1
      property :updated_at, DateTime
  
      belongs_to_entity :cart
    end
@@@

!SLIDE

# Shopping Cart

@@@ ruby
    class Cart
      include Base
      
      property :state, String, :default => 'browse'
      property :updated_at, DateTime
      
      has_descendants :cart_items
      ...
    end
    
    class CartItem
      include Base
      
      property :count, Integer, :default => 1
  
      belongs_to_entity :item
    end
@@@

!SLIDE

# Portability
 - Bulk uploader and downloader
 - Common APIs
   - DataMapper
   - Memcached
 - Familiar structure
   - queues
   - cron jobs

!SLIDE
# Portability
## Up to you how portable you are:
<br />
@@@ ruby
    class User
      property :id, Serial
      property :name, String
      property :email, String
    end

    User.create(:name => 'Nobody',
                :email => 'nobody@example.com')

    User.first(:email => 'nobody@example.com')

    User.auto_migrate! # on sqlite3, MySQL, etc
@@@