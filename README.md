FileClip [![Build Status](https://travis-ci.org/ScotterC/fileclip.png?branch=master)](https://travis-ci.org/ScotterC/fileclip) [![Coverage Status](https://coveralls.io/repos/ScotterC/fileclip/badge.png?branch=master)](https://coveralls.io/r/ScotterC/fileclip?branch=master)
========

A FilePicker / PaperClip mashup.  Use Filepicker for uploads and paperclip to process them.

### What FileClip Does

FileClip saves a filepicker url to your image table which is then
processed by paperclip after the object is saved.  This allows filepicker urls with paperclip styles while the image is being processed and the possibility for seamless image handling without having to process anything on your rails servers.

## Minimum Viable Setup

### Add to Paperclip table
````
class AddFileClipToImages < ActiveRecord::Migration
  def up
    add_column :images, :filepicker_url, :string
  end

  def down
    remove_column :images, :filepicker_url
  end
end
````

### In Initializer
````
# config/initializers/fileclip.rb
FileClip.configure do |config|
  config.filepicker_key = 'XXXXXXXXXXXXXXXXXXX'
  config.services = ["COMPUTER", "DROPBOX"]     # Defaults to ["COMPUTER"]
  config.max_size = 20                          # Megabytes, defaults to 20
  config.storage_path = "/assets/"              # Defaults to "/fileclip/"
  config.mime_types = "images/jpeg"             # Defaults to "images/*"
  config.file_access = "private"                # Defaults to "public"
  config.excluded_environments = []             # Defaults to ["test"]
  config.default_service = "DROPBOX"            # Defaults to "COMPUTER"
end
````

### In Model
````
# models/image.rb
class Image << ActiveRecord::Base

  has_attached_file :attachment

  fileclip :attachment
end
````

### In View
````
# Loads Filepicker js, and FileClip js
<%= fileclip_js_include_tag %>

<%= form_for(Image.new) do |f| %>

  # provides a link that can be styled any way you choose
  # launches filepicker dialog and saves link to hidden field
  <%= link_to_fileclip "Choose a File", f %>

  <%= f.submit %>
<% end %>

# Specify a callback function that gets called when Filepicker completes
<%= link_to_fileclip "Choose a File", f, :callback => 'window.MyApp.filepickerCallback' %>

# For more control you can disable automatic Javascript initialization.
# You'll need to initialize the FileClip element yourself.
<%= link_to_fileclip "Choose a File", f, :class => '.my-filepicker', :js => false %>

# In your Javascript framework
(new FileClip).button('.my-filepicker');

````

#### Current FilePicker options hardcoded
* container modal
* location is S3

Features:
* Unobtrusive.  Normal paperclip uploads still work


#### Gotchas

This paperclip validation will return errors even if filepicker url is present:
````
  validates :attachment, :attachment_presence => true
````

However, this will work fine.  It'll skip the attachment check if a filepicker url is present and validate if it's not.
````
  validates_attachment :attachment, :size => { :in => 0..1000 }, :presence => true
````
