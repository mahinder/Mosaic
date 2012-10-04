class Object < BasicObject
  include Kernel

  ARGF = ARGF
  ARGV = []
  ArgumentError = ArgumentError
  Array = Array
  BasicObject = BasicObject
  Bignum = Bignum
  Binding = Binding
  CROSS_COMPILING = nil
  Class = Class
  Comparable = Comparable
  Complex = Complex
  Config = RbConfig
  Data = Data
  Date = Date
  DateTime = DateTime
  Dir = Dir
  ENV = {"XDG_SESSION_PATH"=>"/org/freedesktop/DisplayManager/Session0", "JAVA_HOME"=>"/opt/jdk1.7.0", "SSH_AGENT_PID"=>"2235", "rvm_version"=>"1.15.8 (stable)", "SESSION_MANAGER"=>"local/sun:@/tmp/.ICE-unix/2195,unix/sun:/tmp/.ICE-unix/2195", "GNOME_DESKTOP_SESSION_ID"=>"this-is-deprecated", "COMPIZ_CONFIG_PROFILE"=>"ubuntu", "XDG_SESSION_COOKIE"=>"25e083d66fc81f06ce87916200000009-1348495481.308213-1884568797", "GDMSESSION"=>"ubuntu", "MANDATORY_PATH"=>"/usr/share/gconf/ubuntu.mandatory.path", "PWD"=>"/home/shakti/Desktop", "NLSPATH"=>"/usr/dt/lib/nls/msg/%L/%N.cat", "MY_RUBY_HOME"=>"/home/shakti/.rvm/rubies/ruby-1.9.3-p194", "PATH"=>"/home/shakti/.rvm/gems/ruby-1.9.3-p194@mosaic/bin:/home/shakti/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/shakti/.rvm/rubies/ruby-1.9.3-p194/bin:/home/shakti/.rvm/bin:/opt/jdk1.7.0/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/jdk1.7.0/bin", "XDG_CONFIG_DIRS"=>"/etc/xdg/xdg-ubuntu:/etc/xdg", "XDG_CURRENT_DESKTOP"=>"Unity", "APTANA_VERSION"=>"3.1.1.201204131931", "rvm_env_string"=>"ruby-1.9.3-p194@mosaic", "XAUTHORITY"=>"/home/shakti/.Xauthority", "rvm_path"=>"/home/shakti/.rvm", "rvm_ruby_string"=>"ruby-1.9.3-p194", "XDG_SEAT_PATH"=>"/org/freedesktop/DisplayManager/Seat0", "LC_COLLATE"=>"en_US.UTF-8", "GEM_PATH"=>"/home/shakti/.rvm/gems/ruby-1.9.3-p194@mosaic:/home/shakti/.rvm/gems/ruby-1.9.3-p194@global", "GTK_MODULES"=>"canberra-gtk-module:canberra-gtk-module", "GNOME_KEYRING_CONTROL"=>"/tmp/keyring-Bg46ux", "SHLVL"=>"1", "XFILESEARCHPATH"=>"/usr/dt/app-defaults/%L/Dt", "__array_start"=>"0", "LC_MESSAGES"=>"en_US.UTF-8", "XDG_DATA_DIRS"=>"/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/", "rvm_prefix"=>"/home/shakti", "LOGNAME"=>"shakti", "GPG_AGENT_INFO"=>"/tmp/keyring-Bg46ux/gpg:0:1", "IRBRC"=>"/home/shakti/.rvm/rubies/ruby-1.9.3-p194/.irbrc", "RUBY_VERSION"=>"ruby-1.9.3-p194", "SSH_AUTH_SOCK"=>"/tmp/keyring-Bg46ux/ssh", "LD_LIBRARY_PATH"=>"/opt/jdk1.7.0/jre/lib/i386/client:/opt/jdk1.7.0/jre/lib/i386:", "SHELL"=>"/bin/bash", "DBUS_SESSION_BUS_ADDRESS"=>"unix:abstract=/tmp/dbus-VnFgilspXh,guid=198acea603b1b5579c0e460e00000023", "LC_CTYPE"=>"en_US.UTF-8", "rvm_bin_path"=>"/home/shakti/.rvm/bin", "GNOME_KEYRING_PID"=>"2184", "LANGUAGE"=>"en_US:en", "_first"=>"0", "escape_flag"=>"1", "_second"=>"1", "GEM_HOME"=>"/home/shakti/.rvm/gems/ruby-1.9.3-p194@mosaic", "DESKTOP_SESSION"=>"ubuntu", "DISPLAY"=>":0.0", "USER"=>"shakti", "UBUNTU_MENUPROXY"=>"libappmenu.so", "HOME"=>"/home/shakti", "DEFAULTS_PATH"=>"/usr/share/gconf/ubuntu.default.path", "LANG"=>"en_IN"}
  EOFError = EOFError
  Encoding = Encoding
  EncodingError = EncodingError
  Enumerable = Enumerable
  Enumerator = Enumerator
  Errno = Errno
  Etc = Etc
  Exception = Exception
  FALSE = false
  FalseClass = FalseClass
  Fiber = Fiber
  FiberError = FiberError
  File = File
  FileTest = FileTest
  FileUtils = FileUtils
  Fixnum = Fixnum
  Float = Float
  FloatDomainError = FloatDomainError
  GC = GC
  Gem = Gem
  Hash = Hash
  IO = IO
  IOError = IOError
  IndexError = IndexError
  Integer = Integer
  Interrupt = Interrupt
  Kernel = Kernel
  KeyError = KeyError
  LoadError = LoadError
  LocalJumpError = LocalJumpError
  Marshal = Marshal
  MatchData = MatchData
  Math = Math
  Method = Method
  Module = Module
  Mutex = Mutex
  NIL = nil
  NameError = NameError
  NilClass = NilClass
  NoMemoryError = NoMemoryError
  NoMethodError = NoMethodError
  NotImplementedError = NotImplementedError
  Numeric = Numeric
  OUTPUT_PATH = "/home/shakti/v2/ezzie/.metadata/.plugins/com.aptana.ruby.core/-1132820389/4/"
  Object = Object
  ObjectSpace = ObjectSpace
  Proc = Proc
  Process = Process
  Psych = Psych
  RUBY_COPYRIGHT = "ruby - Copyright (C) 1993-2012 Yukihiro Matsumoto"
  RUBY_DESCRIPTION = "ruby 1.9.3p194 (2012-04-20 revision 35410) [i686-linux]"
  RUBY_ENGINE = "ruby"
  RUBY_PATCHLEVEL = 194
  RUBY_PLATFORM = "i686-linux"
  RUBY_RELEASE_DATE = "2012-04-20"
  RUBY_REVISION = 35410
  RUBY_VERSION = "1.9.3"
  Random = Random
  Range = Range
  RangeError = RangeError
  Rational = Rational
  RbConfig = RbConfig
  Regexp = Regexp
  RegexpError = RegexpError
  RubyVM = RubyVM
  RuntimeError = RuntimeError
  STDERR = IO.new
  STDIN = IO.new
  STDOUT = IO.new
  ScanError = StringScanner::Error
  ScriptError = ScriptError
  SecurityError = SecurityError
  Signal = Signal
  SignalException = SignalException
  StandardError = StandardError
  StopIteration = StopIteration
  String = String
  StringIO = StringIO
  StringScanner = StringScanner
  Struct = Struct
  Syck = Syck
  Symbol = Symbol
  SyntaxError = SyntaxError
  SystemCallError = SystemCallError
  SystemExit = SystemExit
  SystemStackError = SystemStackError
  TOPLEVEL_BINDING = #<Binding:0x96abff4>
  TRUE = true
  TSort = TSort
  Thread = Thread
  ThreadError = ThreadError
  ThreadGroup = ThreadGroup
  Time = Time
  TrueClass = TrueClass
  TypeError = TypeError
  URI = URI
  UnboundMethod = UnboundMethod
  YAML = Psych
  ZeroDivisionError = ZeroDivisionError
  Zlib = Zlib

  def self.yaml_tag(arg0)
  end


  def psych_to_yaml(arg0, arg1, *rest)
  end

  def to_yaml(arg0, arg1, *rest)
  end

  def to_yaml_properties
  end


  protected


  private

  def dir_names(arg0)
  end

  def file_name(arg0)
  end

  def get_classes
  end

  def grab_instance_method(arg0, arg1)
  end

  def print_args(arg0)
  end

  def print_instance_method(arg0, arg1)
  end

  def print_method(arg0, arg1, arg2, arg3, arg4, *rest)
  end

  def print_type(arg0)
  end

  def print_value(arg0)
  end

end
