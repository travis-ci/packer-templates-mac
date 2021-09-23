cask "java" do
  version "17,35:0d483333a00540d886896bac774ff48b"
  sha256 "18e11cf9bbc6f584031e801b11ae05a233c32086f8e1b84eb8a1e9bb8e1f5d90"

  url "https://download.java.net/java/GA/jdk#{version.before_comma}/#{version.after_colon}/#{version.after_comma.before_colon}/GPL/openjdk-#{version.before_comma}_macos-x64_bin.tar.gz"
  name "OpenJDK"
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"

  artifact "jdk-#{version.before_comma}.jdk", target: "/Library/Java/JavaVirtualMachines/openjdk-#{version.before_comma}.jdk"
end

