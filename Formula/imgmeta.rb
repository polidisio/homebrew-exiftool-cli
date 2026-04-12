class Imgmeta < Formula
  desc "Personal CLI tool for extracting, exporting, and removing EXIF metadata from photos"
  homepage "https://github.com/polidisio/exiftool-cli"
  license "MIT"
  url "https://github.com/polidisio/exiftool-cli/archive/refs/heads/main.tar.gz"
  version "HEAD"

  depends_on "python@3.11"

  def install
    libexec.mkpath

    system "curl", "-sL", "https://github.com/polidisio/exiftool-cli/archive/refs/heads/main.tar.gz", "-o", "#{libexec}/src.tar.gz"
    system "tar", "-xzf", "#{libexec}/src.tar.gz", "-C", libexec
    system "rm", "#{libexec}/src.tar.gz"

    src_dir = Dir.glob("#{libexec}/exiftool-cli*").first
    raise "Source directory not found" if src_dir.nil?

    # Create venv and install package
    venv_dir = libexec/"venv"
    system "#{Formula["python@3.11"].opt_bin}/python3.11", "-m", "venv", venv_dir
    system "#{venv_dir}/bin/pip", "install", "--target=#{venv_dir}/lib",
          "Pillow>=10.0.0", "piexif>=1.1.3", "click>=8.1.0", "colorama>=0.4.6"

    # Install entry point
    bin.mkpath
    (bin/"imgmeta").write <<~SCRIPT
      #!/bin/bash
      exec #{venv_dir}/bin/python -m exiftool_cli.cli "$@"
    SCRIPT
    chmod 0555, bin/"imgmeta"
  end

  test do
    system "#{bin}/imgmeta", "--version"
  end
end
