class Camembert < Formula
  desc "Interactive disk-usage explorer for the terminal: Unicode pie chart with mouse and keyboard drill-down."
  homepage "https://github.com/SouquieresAdam/camembert"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.4/camembert-aarch64-apple-darwin.tar.xz"
      sha256 "564752508b86ede1cf1fbf95c3871a7d7c00798122ef35312c1e2970c588460d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.4/camembert-x86_64-apple-darwin.tar.xz"
      sha256 "4b4858b330f9f5ad48c26c30f1228a7b835048b336f18c96a95a5f769e3ea667"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.4/camembert-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "150ea5ea1ac7e991a05b05f5c6659e808f9d70837f2b5f81651bf6fdb2b261aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/SouquieresAdam/camembert/releases/download/v0.1.4/camembert-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "725c08304d7d6de110ac91a880ca34e1396bcd081fbb6608f5dd3a2011476ef5"
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
