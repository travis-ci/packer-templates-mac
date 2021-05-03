cask "java" do
  version "16.0.1,9:7147401fd7354114ac51ef3e1328291f"
  sha256 "6098f839954439d4916444757c542c1b8778a32461706812d41cc8bbefce7f2f"

  url "https://download.java.net/java/GA/jdk#{version.before_comma}/#{version.after_colon}/#{version.after_comma.before_colon}/GPL/openjdk-#{version.before_comma}_osx-x64_bin.tar.gz"
  name "OpenJDK"
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"

  artifact "jdk-#{version.before_comma}.jdk", target: "/Library/Java/JavaVirtualMachines/openjdk-#{version.before_comma}.jdk"
end
