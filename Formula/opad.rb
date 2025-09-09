class Opad < Formula
  desc "Easily manage package version across multiple package manager systems in mono repositories"
  homepage "https://github.com/hougesen/opad?tab=readme-ov-file"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/opad/releases/download/v0.1.1/opad-aarch64-apple-darwin.tar.xz"
      sha256 "c8906aa41f34fd5488232dbb8b868636bbe30bdc8a568b6d61ac463d3adeb519"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/opad/releases/download/v0.1.1/opad-x86_64-apple-darwin.tar.xz"
      sha256 "eb24b78011c9597937146e16403e47b419c1a1f824ec1d36be59a4d720a0f380"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/opad/releases/download/v0.1.1/opad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8d873e95169a5dee4ffdd80e4a9f3da24bc5d3cbe408315ffa8f2fbc9fd3d08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/opad/releases/download/v0.1.1/opad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "265b99bc7d237df3462243da4deec6afe926723757c8dc56d3933a71e868906c"
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
