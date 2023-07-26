require 'formula'

class NoOpDownloadStrategy < AbstractDownloadStrategy
# Don't do anything.
end

class Cfssl < Formula
  head 'https://github.com/cloudflare/cfssl', :using => NoOpDownloadStrategy
  url 'https://github.com/cloudflare/cfssl/archive/v1.6.4.zip'
  sha256 '9849dfd1fd1e78f23fb601893f861d15226c97c5748da387315d8dd715ad1238'
  homepage 'https://github.com/cloudflare/cfssl'
  version 'v1.6.4'

  depends_on 'go' => :build

  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      system 'go', 'get', 'github.com/cloudflare/cfssl'
      bin.install 'bin/cfssl'
    else
      chdir '..' do
        ENV['GOPATH'] = Dir.pwd
        mkdir 'src/github.com/cloudflare'
        symlink '../../../cfssl-v1.6.4', 'src/github.com/cloudflare/cfssl'
        system 'go', 'install', 'github.com/cloudflare/cfssl/cmd/cfssl'
        bin.install 'bin/cfssl'
      end
    end
  end

  test do
    system "#{bin}/cfssl", "version"
  end
end
