class Kdlfmt < Formula
  desc "A code formatter for kdl documents."
  homepage "https://github.com/hougesen/kdlfmt?tab=readme-ov-file"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.7/kdlfmt-aarch64-apple-darwin.tar.xz"
      sha256 "286170db398d3d2bb35eac0dc02d0585a56b05427b65ebb1a38835ab3a51663e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.7/kdlfmt-x86_64-apple-darwin.tar.xz"
      sha256 "5254b7b5e0f13c02929c9463d8cfbc195b06bca170611fac404e7c56bc03845f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.7/kdlfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ddbcc630e6a8d93b900fb5252b5182736064fc03f3876fbf8544b9d94f0fb70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.7/kdlfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b1308797646f4e4cbe254c5eb27779bf6450e5386e2644acc46c5b7316783ab9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "kdlfmt" if OS.mac? && Hardware::CPU.arm?
    bin.install "kdlfmt" if OS.mac? && Hardware::CPU.intel?
    bin.install "kdlfmt" if OS.linux? && Hardware::CPU.arm?
    bin.install "kdlfmt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
