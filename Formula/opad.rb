class Opad < Formula
  desc "Easily manage package version across multiple package manager systems in mono repositories"
  homepage "https://github.com/hougesen/opad?tab=readme-ov-file"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/opad/releases/download/v0.1.0/opad-aarch64-apple-darwin.tar.xz"
      sha256 "a642d50f6f45a77783dbb0e3f49be4ab167c10252fd47e9b2431647ad65f2ebd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/opad/releases/download/v0.1.0/opad-x86_64-apple-darwin.tar.xz"
      sha256 "0f967ba8691a31c6c85e511705411a3dd763962b636642e659cfef8733c5c858"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/opad/releases/download/v0.1.0/opad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "706789f83305551ff8c27a6fcc25b24687ae0f8626efd9541414bcaae8bf5000"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/opad/releases/download/v0.1.0/opad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d8990007131eea9950d45615efcd9b431f616c780e5e273c21f8f6b7d252f31"
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
    bin.install "opad" if OS.mac? && Hardware::CPU.arm?
    bin.install "opad" if OS.mac? && Hardware::CPU.intel?
    bin.install "opad" if OS.linux? && Hardware::CPU.arm?
    bin.install "opad" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
