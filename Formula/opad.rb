class Opad < Formula
  desc "Easily manage package version across multiple package manager systems in mono repositories"
  homepage "https://github.com/hougesen/opad?tab=readme-ov-file"
  version "0.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/opad/releases/download/v0.0.0/opad-aarch64-apple-darwin.tar.xz"
      sha256 "73dee039a1d8035d6595564f291b6aeeab875e86ab32495344fd8ddcc30564a5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/opad/releases/download/v0.0.0/opad-x86_64-apple-darwin.tar.xz"
      sha256 "c355d38d32d2781c1c5dbe91f8e476df09d4afe3b8a9f9c027895f3a3787c44a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/opad/releases/download/v0.0.0/opad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "76bac68049697dabd80135c58a3851560fef129ab3c81717c24f811e9042d818"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/opad/releases/download/v0.0.0/opad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f9ade78d5d3516ca1401c441c60bbf1db53320d806001af423f9def1c4ace88"
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
