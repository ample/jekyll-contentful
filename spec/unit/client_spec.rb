require 'spec_helper'
require 'jekyll'
require 'active_support/inflector'

describe Jekyll::Contentful::Client do

  before do
    Jekyll.logger.adjust_verbosity(quiet: true)
    base = File.join(__dir__, '../dummy')
    @site = Jekyll::Contentful::Client.scaffold(base)
    @client = Jekyll::Contentful::Client.new(site: @site)
  end

  it 'should scaffold Jekyll site' do
    expect(@site).to be_instance_of(Jekyll::Site)
  end

  it 'should return content_types' do
    expect(@client.send(:content_types)).to match_array(['articles', 'podcasts'])
  end

  it 'should return config' do
    expect(@client.send(:cfg, 'articles')).to be_instance_of(Hash)
  end

  it 'should return client object' do
    expect(@client.send(:client)).to be_instance_of(Contentful::Client)
  end

  it 'should return collections glob' do
    @site.collections['articles'].read
    glob = @client.send(:collections_glob, 'articles')
    expect(glob).to include(@site.collections['articles'].first.path)
  end

  context 'get_entries()' do
    cassette 'contentful/articles'

    it 'should return document instances for each CF entry' do
      documents = @client.send(:get_entries, 'articles')
      expect(documents.all?{|d| d.class.name == 'Jekyll::Contentful::Document' }).to be(true)
    end
  end

end