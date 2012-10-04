class Object < BasicObject
  include Kernel

  ARGF = ARGF
  ARGV = []
  ArgumentError = ArgumentError
  Array = Array
  Bignum = Bignum
  Binding = Binding
  Class = Class
  Comparable = Comparable
  Complex = Complex
  Data = Data
  Dir = Dir
  ENV = {"XDG_SESSION_PATH"=>"/org/freedesktop/DisplayManager/Session0", "rvm_examples_path"=>"/home/shakti/.rvm/examples", "JAVA_HOME"=>"/opt/jdk1.7.0", "SSH_AGENT_PID"=>"2241", "rvm_archives_path"=>"/home/shakti/.rvm/archives", "rvm_version"=>"1.8.4", "SESSION_MANAGER"=>"local/sun:@/tmp/.ICE-unix/2201,unix/sun:/tmp/.ICE-unix/2201", "GNOME_DESKTOP_SESSION_ID"=>"this-is-deprecated", "rvm_gemset_name"=>"rails3tutorial", "COMPIZ_CONFIG_PROFILE"=>"ubuntu", "XDG_SESSION_COOKIE"=>"25e083d66fc81f06ce87916200000009-1335754993.586116-165385394", "GDMSESSION"=>"ubuntu", "MANDATORY_PATH"=>"/usr/share/gconf/ubuntu.mandatory.path", "rvm_rubies_path"=>"/home/shakti/.rvm/rubies", "PWD"=>"/home/shakti/Desktop", "rvm_scripts_path"=>"/home/shakti/.rvm/scripts", "rvm_man_path"=>"/home/shakti/.rvm/man", "rvm_environments_path"=>"/home/shakti/.rvm/environments", "rvm_docs_path"=>"/home/shakti/.rvm/docs", "NLSPATH"=>"/usr/dt/lib/nls/msg/%L/%N.cat", "rvm_repos_path"=>"/home/shakti/.rvm/repos", "MY_RUBY_HOME"=>"/home/shakti/.rvm/rubies/ruby-1.9.2-p290", "rvm_patches_path"=>"/home/shakti/.rvm/patches", "PATH"=>"/home/shakti/.rvm/gems/ruby-1.9.2-p290@rails3tutorial/bin:/home/shakti/.rvm/gems/ruby-1.9.2-p290@global/bin:/home/shakti/.rvm/rubies/ruby-1.9.2-p290/bin:/home/shakti/.rvm/bin:/opt/jdk1.7.0/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/jdk1.7.0/bin", "XDG_CONFIG_DIRS"=>"/etc/xdg/xdg-ubuntu:/etc/xdg", "XDG_CURRENT_DESKTOP"=>"Unity", "APTANA_VERSION"=>"3.1.1.201204131931", "rvm_gemsets_path"=>"/home/shakti/.rvm/gemsets", "rvm_usr_path"=>"/home/shakti/.rvm/usr", "rvm_env_string"=>"ruby-1.9.2-p290@rails3tutorial", "rvm_debug_flag"=>"0", "rvm_user_path"=>"/home/shakti/.rvm/user", "rvm_path"=>"/home/shakti/.rvm", "XAUTHORITY"=>"/home/shakti/.Xauthority", "rvm_wrappers_path"=>"/home/shakti/.rvm/wrappers", "rvm_ruby_string"=>"ruby-1.9.2-p290", "XDG_SEAT_PATH"=>"/org/freedesktop/DisplayManager/Seat0", "rvm_reload_flag"=>"0", "LC_COLLATE"=>"en_US.UTF-8", "rvm_src_path"=>"/home/shakti/.rvm/src", "GEM_PATH"=>"/home/shakti/.rvm/gems/ruby-1.9.2-p290@rails3tutorial:/home/shakti/.rvm/gems/ruby-1.9.2-p290@global", "GTK_MODULES"=>"canberra-gtk-module:canberra-gtk-module", "GNOME_KEYRING_CONTROL"=>"/tmp/keyring-f48lLO", "SHLVL"=>"1", "rvm_lib_path"=>"/home/shakti/.rvm/lib", "MOZILLA_FIVE_HOME"=>"/usr/lib/xulrunner-addons", "XFILESEARCHPATH"=>"/usr/dt/app-defaults/%L/Dt", "LC_MESSAGES"=>"en_US.UTF-8", "rvm_verbose_flag"=>"0", "XDG_DATA_DIRS"=>"/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/", "rvm_prefix"=>"/home/shakti", "LOGNAME"=>"shakti", "IRBRC"=>"/home/shakti/.rvm/rubies/ruby-1.9.2-p290/.irbrc", "GPG_AGENT_INFO"=>"/tmp/keyring-f48lLO/gpg:0:1", "rvm_tmp_path"=>"/home/shakti/.rvm/tmp", "rvm_help_path"=>"/home/shakti/.rvm/help", "RUBY_VERSION"=>"ruby-1.9.2-p290", "SSH_AUTH_SOCK"=>"/tmp/keyring-f48lLO/ssh", "LD_LIBRARY_PATH"=>"/opt/jdk1.7.0/jre/lib/i386/client:/opt/jdk1.7.0/jre/lib/i386:", "SHELL"=>"/bin/bash", "DBUS_SESSION_BUS_ADDRESS"=>"unix:abstract=/tmp/dbus-0HYRBuglEb,guid=aec20619a8b28ce512aade1f00000024", "LC_CTYPE"=>"en_US.UTF-8", "rvm_bin_path"=>"/home/shakti/.rvm/bin", "GNOME_KEYRING_PID"=>"2190", "LANGUAGE"=>"en_US:en", "GEM_HOME"=>"/home/shakti/.rvm/gems/ruby-1.9.2-p290@rails3tutorial", "DESKTOP_SESSION"=>"ubuntu", "DISPLAY"=>":0.0", "USER"=>"shakti", "UBUNTU_MENUPROXY"=>"libappmenu.so", "HOME"=>"/home/shakti", "rvm_loaded_flag"=>"1", "DEFAULTS_PATH"=>"/usr/share/gconf/ubuntu.default.path", "rvm_user_install_flag"=>"1", "LANG"=>"en_IN", "rvm_log_path"=>"/home/shakti/.rvm/log"}
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
  OUTPUT_PATH = "/home/shakti/v2/ezzie/.metadata/.plugins/com.aptana.ruby.core/548467003/4/"
  Object = Object
  ObjectSpace = ObjectSpace
  Proc = Proc
  Process = Process
  RUBY_COPYRIGHT = "ruby - Copyright (C) 1993-2011 Yukihiro Matsumoto"
  RUBY_DESCRIPTION = "ruby 1.9.2p290 (2011-07-09 revision 32553) [i686-linux]"
  RUBY_ENGINE = "ruby"
  RUBY_PATCHLEVEL = 290
  RUBY_PLATFORM = "i686-linux"
  RUBY_RELEASE_DATE = "2011-07-09"
  RUBY_REVISION = 32553
  RUBY_VERSION = "1.9.2"
  Random = Random
  Range = Range
  RangeError = RangeError
  Rational = Rational
  Regexp = Regexp
  RegexpError = RegexpError
  RubyVM = RubyVM
  RuntimeError = RuntimeError
  STDERR = IO.new
  STDIN = IO.new
  STDOUT = IO.new
  ScriptError = ScriptError
  SecurityError = SecurityError
  Signal = Signal
  SignalException = SignalException
  StandardError = StandardError
  StopIteration = StopIteration
  String = String
  Struct = Struct
  Symbol = Symbol
  SyntaxError = SyntaxError
  SystemCallError = SystemCallError
  SystemExit = SystemExit
  SystemStackError = SystemStackError
  TOPLEVEL_BINDING = #<Binding:0x909bd1c>
  TRUE = true
  Thread = Thread
  ThreadError = ThreadError
  ThreadGroup = ThreadGroup
  Time = Time
  TrueClass = TrueClass
  TypeError = TypeError
  UnboundMethod = UnboundMethod
  ZeroDivisionError = ZeroDivisionError



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
