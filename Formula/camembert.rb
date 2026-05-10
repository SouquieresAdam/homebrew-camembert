class Camembert < Formula
  desc "Disk-usage explorer en CLI Rust : scanne un dossier et l'affiche en camembert ASCII Unicode interactif (drill-down souris/clavier)."
  homepage "https://github.com/SouquieresAdam/camembert"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.2/camembert-aarch64-apple-darwin.tar.xz"
      sha256 "9969792c80a3565fd4d0ec74146af190b6556ffbc2ad23cf4e0dc641222dd1f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.2/camembert-x86_64-apple-darwin.tar.xz"
      sha256 "70e8f8ed3f31d494880e2c919b3b6d423a720079b04b32da95af5781585bab50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.2/camembert-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e8a28f4d6918eafefbe5fd3f3cef8a68015fd5a07416ba948b6488973d80c7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.2/camembert-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e8b98c98998f12467b4614c2f0289678c4f24ec3aa57cebe2b62053e7a39a2e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "camembert" if OS.mac? && Hardware::CPU.arm?
    bin.install "camembert" if OS.mac? && Hardware::CPU.intel?
    bin.install "camembert" if OS.linux? && Hardware::CPU.arm?
    bin.install "camembert" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
