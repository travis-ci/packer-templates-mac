cask "java" do
  version "15.0.1,9:51f4f36ad4ef43e39d0dfdbaf6549e32"
  sha256 "e1d4868fb082d9202261c5a05251eded56fb805da2d641a65f604988b00b1979"

  url "https://download.java.net/java/GA/jdk#{version.before_comma}/#{version.after_colon}/#{version.after_comma.before_colon}/GPL/openjdk-#{version.before_comma}_osx-x64_bin.tar.gz"
  name "OpenJDK"
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"

  artifact "jdk-#{version.before_comma}.jdk", target: "/Library/Java/JavaVirtualMachines/openjdk-#{version.before_comma}.jdk"
end

