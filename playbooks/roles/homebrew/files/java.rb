cask "java" do
  version "17,35:0d483333a00540d886896bac774ff48b"
  sha256 "6098f839954439d4916444757c542c1b8778a32461706812d41cc8bbefce7f2f"

  url "https://download.java.net/java/GA/jdk#{version.before_comma}/#{version.after_colon}/#{version.after_comma.before_colon}/GPL/openjdk-#{version.before_comma}_osx-x64_bin.tar.gz"
  name "OpenJDK"
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"

  artifact "jdk-#{version.before_comma}.jdk", target: "/Library/Java/JavaVirtualMachines/openjdk-#{version.before_comma}.jdk"
end

