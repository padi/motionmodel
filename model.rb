class Post
  attr_accessor :message
  attr_accessor :id

  # called when an object is loaded from NSUserDefaults
  # this is an initializer, so should return `self`
  def initWithCoder decoder
    self.init
    self.message = decoder.decodeWithObjectForKey "message"
    self.id = decoder.decodeWithObjectForKey "id"
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder encoder
    encoder.encodeObject self.message, forKey: "message"
    encoder.encodeObject self.id, forKey: "id"
  end
end

defaults = NSUserDefaults.standardUserDefaults

post = Post.new
post.message = "hello!"
post.id = 1000

post_as_data = NSKeyedArchiver.archivedDataWithRootObject post
defaults["saved_post"] = post_as_data

# later on, we want to load this post:

post_as_data = defaults["saved_post"]
post = NSKeyedUnarchiver.unarchiveObjectWithData post_as_data

class User
  PROPERTIES = [:id, :name, :email]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key
    }
  end

  def initWithCoder decoder
    self.init
    PROPERTIES.each { |prop|
      value = decoder.decodeObjectForKey prop.to_s
      self.send((prop.to_s + "=").to_s, value) if value
      encoder.encodeObject(self.send(prop), forKey: prop.to_s)
    }
  end
end
