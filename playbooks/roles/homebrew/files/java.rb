cask "java" do
  version "15.0.1,9:51f4f36ad4ef43e39d0dfdbaf6549e32"
  sha256 "aad54ae4766d82ebd0de5189e71bdc6cd7336f0d62fda5eba24f2072a6de34d0"

  url "https://download.java.net/java/GA/jdk#{version.before_comma}/#{version.after_colon}/#{version.after_comma.before_colon}/GPL/openjdk-#{version.before_comma}_osx-x64_bin.tar.gz"
  name "OpenJDK"
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"

  artifact "jdk-#{version.before_comma}.jdk", target: "/Library/Java/JavaVirtualMachines/openjdk-#{version.before_comma}.jdk"
end

