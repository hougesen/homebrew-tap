class Kdlfmt < Formula
  desc "A code formatter for kdl documents."
  homepage "https://github.com/hougesen/kdlfmt?tab=readme-ov-file"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.6/kdlfmt-aarch64-apple-darwin.tar.xz"
      sha256 "1f7d824f8fbe5b8fd32f8e3b3092b005fbb9c1b675de039f43b3df40a7e53263"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.6/kdlfmt-x86_64-apple-darwin.tar.xz"
      sha256 "466ac93f519b264a4cf6c270504601688029b47a2aa0a216ad49f106630e2fa8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.6/kdlfmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4fb01630dbf51f92e938f5711fd0ec2a04ea14f026afa324f6c3bab9cc2968ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hougesen/kdlfmt/releases/download/v0.1.6/kdlfmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5a80935cffe5503aeff27780bd68c0a2d64ceb25c932418784ac4ef288019bdb"
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
