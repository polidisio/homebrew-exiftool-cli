class ExiftoolCli < Formula
  desc "CLI tool for extracting, exporting, and removing EXIF metadata from photos"
  homepage "https://github.com/polidisio/exiftool-cli"
  license "MIT"
  head "https://github.com/polidisio/exiftool-cli.git", branch: "main"

  depends_on "python@3.11"

  def install
    libexec.mkpath
    system "cp", "-r", cached_download, libexec

    bin.mkpath
    (bin/"exiftool-cli").write <<~SCRIPT
      #!/bin/bash
      export PYTHONPATH="#{libexec}"
      exec #{Formula["python@3.11"].opt_bin}/python3.11 -m exiftool_cli.cli "$@"
    SCRIPT
    chmod 0555, bin/"exiftool-cli"

    system "#{Formula["python@3.11"].opt_bin}/pip3.11", "install", "--prefix=#{prefix}",
          "Pillow>=10.0.0", "piexif>=1.1.3", "click>=8.1.0", "colorama>=0.4.6"
  end

  test do
    system "#{bin}/exiftool-cli", "--help"
  end
end
